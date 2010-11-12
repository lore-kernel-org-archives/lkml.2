Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394Ab0KLJ3D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 04:29:03 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46136 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444Ab0KLJ3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 04:29:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=aXtunkNbXbUEooiZykOR8sxZtj01tnQlbPnJjJc97+P4S+u2K+Ohpdk7y5iX/izelt
         ocaqcJPOH8Pza/d5omwBVouUDRyEyBZJ/t35ztL5JlxmYHFF58q1CXmotaLhWvG/au5j
         BLgcJrFzcorbEnCRcS/xh8PQSb86oV/dCcu/c=
Date: Fri, 12 Nov 2010 17:33:45 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
        Cypher Wu <cypher.w@gmail.com>, linux-kernel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
Subject: Re: Kernel rwlock design, Multicore and IGMP
Message-ID: <20101112093345.GC5949@cr0.nay.redhat.com>
References: <AANLkTikvT=x9eBovn2-m6HLqk7wyXSAR3sc9jCQ0C6mL@mail.gmail.com>
 <1289489007.17691.1310.camel@edumazet-laptop>
 <AANLkTik93QUQxSDmwd4Qj-gXQiWWPzd68JPAYAHBAsHR@mail.gmail.com>
 <20101112071323.GB5660@cr0.nay.redhat.com>
 <1289546874.17691.1774.camel@edumazet-laptop>
 <20101112081945.GA5949@cr0.nay.redhat.com>
 <1289553759.3185.1.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1289553759.3185.1.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 10:22:39AM +0100, Eric Dumazet wrote:
>Le vendredi 12 novembre 2010 à 16:19 +0800, Américo Wang a écrit :
>> On Fri, Nov 12, 2010 at 08:27:54AM +0100, Eric Dumazet wrote:
>
>> >A RCU conversion is far more complex.
>> >
>> 
>> Yup.
>
>
>Well, actually this is easy in this case.
>
>I'll post a patch to do this RCU conversion.
>

Cool! Please keep me in Cc.

Some conversions from rwlock to RCU are indeed complex,
don't know about this case.

Anyway, patch please. :)
