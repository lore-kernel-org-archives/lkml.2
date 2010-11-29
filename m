Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab0K2VAU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 16:00:20 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:36174 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab0K2VAS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 16:00:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=B7NvPqJqbNUDUh4/5u3YwZ73T+7Vc77+PIZDDqvdk8a0GNDTG4iTfyKKQs+y3PJVlm
         VrOjDACYFN4TNSzMVVDwfG5nmDGtE+6Yu9n2o2pHAfHjSDptzqG4ZmQKd7QdJzREEtZc
         Nh9Udex0nnAPlYD/smDfNYCMvZsIISQ3v99uo=
MIME-Version: 1.0
In-Reply-To: <AANLkTikmzhM-XpXrtOys3DbrG00brnXx0YVYSpHt-vrs@mail.gmail.com>
References: <AANLkTimewZ4QhxzL2vOYYV85pegy8Fu6Rb4XUAPqGUXS@mail.gmail.com>
	<20101129081619.GD5218@cr0.nay.redhat.com>
	<AANLkTinnJjqmXmbpAYmV9Tsc0VJV=WDM+GY6Gi1cJFCB@mail.gmail.com>
	<20101129085250.GF5218@cr0.nay.redhat.com>
	<AANLkTikmzhM-XpXrtOys3DbrG00brnXx0YVYSpHt-vrs@mail.gmail.com>
Date: Mon, 29 Nov 2010 16:00:17 -0500
Message-ID: <AANLkTim299hoNcUhBU3j6MN248QsbQC7+R67CrgdF_b3@mail.gmail.com>
Subject: Re: [PATCH] Built kernel without -O2 option
From: Arnaud Lacombe <lacombar@gmail.com>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Hui Zhu <teawater@gmail.com>, linux-kernel@vger.kernel.org,
        gdb@sourceware.org, hellogcc@freelists.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Nov 29, 2010 at 3:51 PM, richard -rw- weinberger
<richard.weinberger@gmail.com> wrote:
> On Mon, Nov 29, 2010 at 9:52 AM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
>>> [...]
>> No, I didn't mean this, I meant some function that have to be inlined
>> are those who only work when being inlined, e.g. current_text_addr().
>
> Can you please explain to me why some functions work only when they are inlined?
> Is it because of asm() black magic?
>
obviously, you do not understand the purpose of this function...

 - Arnaud
