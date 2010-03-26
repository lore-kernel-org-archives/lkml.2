Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908Ab0CZGNP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 02:13:15 -0400
Received: from mail-qy0-f182.google.com ([209.85.221.182]:55054 "EHLO
	mail-qy0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438Ab0CZGNL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 02:13:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=O/lBDrOiUPf53CpxuxsWMuWzbs/wDnYNlowHOseWw+bftzpXJLqCLnqAFfVoRijYCp
         PC5Eb4teiZ1N7LVMiKmztfoDN3IWeSTe2XQBm7XX9XCNXrl6Ubd8+69/+64hLP1h+EYQ
         tewyB7XhntFZeAHtcyCzxh/cqwnXKPX+2jEfc=
MIME-Version: 1.0
In-Reply-To: <3Qs6IGJaRe.A.GfC.oBopLB@chimera>
References: <M9dVcHY7TxH.A.2GC.ZBopLB@chimera>
	 <3Qs6IGJaRe.A.GfC.oBopLB@chimera>
Date: Fri, 26 Mar 2010 14:13:10 +0800
Message-ID: <2375c9f91003252313x69aae301h1290c81891f156d3@mail.gmail.com>
Subject: Re: [Bug #15555] 2.6.34-rc1: kernel BUG at mm/slab.c:2989!
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 4:13 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.33.  Please verify if it still should be listed and let the tracking team
> know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=15555
> Subject         : 2.6.34-rc1: kernel BUG at mm/slab.c:2989!
> Submitter       : Américo Wang <xiyou.wangcong@gmail.com>
> Date            : 2010-03-10 8:29 (12 days old)
> Message-ID      : <2375c9f91003100029q7d64bbf7xce15eee97f7e2190@mail.gmail.com>
> References      : http://marc.info/?l=linux-kernel&m=126820979017089&w=2
>

I can't reproduce this bug any more.
