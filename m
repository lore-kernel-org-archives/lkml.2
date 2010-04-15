Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487Ab0DOQRV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 12:17:21 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:51212 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806Ab0DOQRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 12:17:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=BIRDQO7eugeiHnBPpIXBv8k2uzjFuZJLSANNmWc5zdsYfCkWQhTHZ7hh7adBgnJc37
         oNdXQauMMfh/dWazF3WP/3DVqjytQ6iQDeN0BDHk1L0v2KG5OlQTN+4SlVIz5eK7Zb3D
         AWuucjyt5Qqgx6PQrPbjwXousdlAe97KYTi8o=
MIME-Version: 1.0
In-Reply-To: <20100415152429.GE2471@linux.vnet.ibm.com>
References: <1271271162.9281.1.camel@localhost>
	 <20100415152429.GE2471@linux.vnet.ibm.com>
Date: Thu, 15 Apr 2010 18:17:18 +0200
Message-ID: <r2y8aa016e11004150917u865ce90nd6adb5e13a802cc@mail.gmail.com>
Subject: Re: WARNING: at kernel/lockdep.c:2696 lockdep_init_map+0xd2/0x108()
From: Dhaval Giani <dhaval.giani@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       Jiri Kosina <jkosina@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 15, 2010 at 5:24 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Wed, Apr 14, 2010 at 08:52:42PM +0200, Dhaval Giani wrote:
>> Hi Peter,
>>
>> I seem to be hitting this on bootup on a recent-ish git kernel (post
>> -rc4).
>
> Is this addressed by ebd09ec93c90c8ec571d7e166832fb1fc705bf5e?
> (http://lkml.org/lkml/2010/4/6/62)
>

That patch was already in my kernel. Jiri's patch though was the magic balm :-).

Thanks,
Dhaval
