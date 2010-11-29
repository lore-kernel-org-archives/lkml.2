Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab0K2Coj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 21:44:39 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43777 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112Ab0K2Cog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 21:44:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=k2zOv00H5KQa/AziUjd9ck2WRMU2mi3qMtERlpCappx9kyUsmQv4/e2GcJAIqANP0i
         WNEZjk/1lzvunlDl74vMgOcwt2AYqirYDQEWHwGpPNhyLL+CGiXIvdr7pnRjVW9yVZJj
         ZDjDVHDBFq4Ex1ecyMrsm7V8LI2iUJzKLkYzg=
Date: Mon, 29 Nov 2010 10:49:18 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Microcai <microcai@fedoraproject.org>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        linux-console@vger.kernel.org
Subject: Re: VT console need rewrite
Message-ID: <20101129024918.GA5218@cr0.nay.redhat.com>
References: <1290941875.13526.15.camel@cai.gentoo>
 <73BC440E-833E-4E1B-ACCC-5D68BAB89D83@mit.edu>
 <1290951770.13526.18.camel@cai.gentoo>
 <AANLkTimQDWHo4-8-H+5bB_uzrgzU=gqbDBuerq983moR@mail.gmail.com>
 <1290954545.13526.27.camel@cai.gentoo>
 <20101128191152.GV10602@const.famille.thibault.fr>
 <1290993006.877.0.camel@cai.gentoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1290993006.877.0.camel@cai.gentoo>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 09:10:06AM +0800, Microcai wrote:
>在 2010-11-28日的 20:11 +0100，Samuel Thibault写道：
>> Microcai, le Sun 28 Nov 2010 22:29:05 +0800, a écrit :
>> > So, here is the design according to your description  .. 
>> > 
>> > JUST export /dev/fb and /dev/pts and /dev/console
>> > The kernel use /dev/console, but invisible. 
>> > The rest of the world uses /dev/pts
>> > 
>> > Make init using /dev/fb to display boot message, and agetty runs
>> > on /dev/pts
>> 
>> Errr, but that already exists, that's fbterm...
>> 
>> Samuel
>
>Every time someone try to implement something , some other guy will jump
>out and say, that already exist, in user-space ..... blablablabla
>

Remember, remember, kernel provides a mechanism, not a policy.
(From this point, auto-groups *does* break it.)
