Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab0CZGLn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 02:11:43 -0400
Received: from mail-qy0-f182.google.com ([209.85.221.182]:58840 "EHLO
	mail-qy0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874Ab0CZGLl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 02:11:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OrYkEJ6d7tjBCBt1dmnvEu3QoOt7M3bfWAL2fUU9ahvlac9jt4OReKgTvMIUz28OAd
         vwrazX+E/NTcbxAMw8nGLihF/wXVfidzkYIN9g3oi7f0nfGRYhm/9kNKxDxjl+tGqjJC
         WrCnZ1ausXJShGf/yCd11xmdA6tdelbjo4wQ0=
MIME-Version: 1.0
In-Reply-To: <hTwaxgnIZ2O.A.J8F.wQopLB@chimera>
References: <QQGfxbJf48H.A.NFD.uNopLB@chimera>
	 <hTwaxgnIZ2O.A.J8F.wQopLB@chimera>
Date: Fri, 26 Mar 2010 14:11:39 +0800
Message-ID: <2375c9f91003252311j24d0a13ekbe1484f0d789e392@mail.gmail.com>
Subject: Re: [Bug #15142] sysfs-related lockdep warning in __blkdev_get
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Matti Aarnio <matti.aarnio--kernel-bugzilla@zmailer.org>,
       NeilBrown <neilb@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 4:30 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.32 and 2.6.33.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.32 and 2.6.33.  Please verify if it still should
> be listed and let the tracking team know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=15142
> Subject         : sysfs-related lockdep warning in __blkdev_get
> Submitter       : Matti Aarnio <matti.aarnio--kernel-bugzilla@zmailer.org>
> Date            : 2010-01-25 13:38 (56 days old)
> Handled-By      : NeilBrown <neilb@suse.de>
> Patch           : https://bugzilla.kernel.org/attachment.cgi?id=25085
>

This is supposed to be fixed by Eric's patch which is now in upstream.

Thanks!
