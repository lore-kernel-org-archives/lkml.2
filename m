Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab1EVCAa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 22:00:30 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46540 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087Ab1EVCA1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 22:00:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QD/l29isXhGBQBs/Hf8IGyibp2gZs0V9X9LiQucTWJ7nPoiNdkXKJCOVoiWLSSldiN
         KsBAAwuhfu96ZKZdbcvs7wlqglAuV8IIjmbI/sFtJkRZe8aghYWWHmYE2moDYKhlmZSU
         NXYSgG+YYJrBg5FEjqMITHKl7i57osrOTYuzc=
MIME-Version: 1.0
In-Reply-To: <17610.1305915959@localhost>
References: <201105120025.34531.rjw@sisk.pl>
	<20633.1305565337@localhost>
	<BANLkTin7NgUMXSVyKn6P0TCrFZ5uaaRL1w@mail.gmail.com>
	<201105182144.37713.rjw@sisk.pl>
	<BANLkTimZ9pe-FhkJYHTG1Jx8MUPrMHSFbA@mail.gmail.com>
	<BANLkTim9_1Xt8oE4awbCO1iKUW96YUOv_A@mail.gmail.com>
	<10124.1305906020@localhost>
	<20110520154341.GL31426@htj.dyndns.org>
	<BANLkTi=iNjWsaYCJqP057FkhAXtab5nS=Q@mail.gmail.com>
	<17610.1305915959@localhost>
Date: Sat, 21 May 2011 19:00:26 -0700
Message-ID: <BANLkTimnfJmMWmSkFiehNeE95z7kxgeQPw@mail.gmail.com>
Subject: Re: [PATCH v2.6.38-rc7] Revert "libata: ahci_start_engine compliant
 to AHCI spec"
From: Jian Peng <jipeng2005@gmail.com>
To: Valdis.Kletnieks@vt.edu
Cc: Tejun Heo <tj@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Jeff Garzik <jgarzik@pobox.com>,
        Michael Leun <lkml20100708@newton.leun.net>, linux-ide@vger.kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI, Valdis,

This patch is on top of reverted patch 81ca7e4. So you should not
revert 81ca7e4 before applying this new one.

Best regards,
Jian

On Fri, May 20, 2011 at 11:25 AM, <Valdis.Kletnieks@vt.edu> wrote:
>
> On Fri, 20 May 2011 10:02:56 PDT, Jian Peng said:
> > --20cf307f38f6d842a904a3b81730
>
> > You are both right that adding this majic 5ms delay at this place should not
> > be the final solution.
> >
> > If this magic 5ms delay works on other affected systems, I plan to post a
> > new patch that inside ahci_start_engine(), still perform same check, and
> > show warning message if failed, but will set a flag, then still set START
> > bit, and if there is such failure flag, add 5ms delay.
> >
> > Valdis, could you apply the following patch and retest it?
>
> I should be able to do that this weekend.  To clarify - should this be with the
> problem commit 270dac35c26433d06a89150c51e75ca0181ca7e4 applied, or reverted?
>
