Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab1FOU4t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 16:56:49 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:34287 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251Ab1FOU4q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 16:56:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=izLHArmZ8XvIWsJWP4sxAlmAVILEl7rQ6BvalhfeUV42W5assQXMeZGoGb8NXQJERG
         Q/8taMzb2uuMaNaSIIgaUihtj8i9sPoGszYdKJvtM3Sp1AvTEJqbP5X9Wi5aXfbzGMSK
         XM9MwAWRKB5oDuU4Oe5VdymJkU1mLmL5PjRm4=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [Bug #34002] [REGRESSION] [2.6.39-rc3] Wrong resolution in framebuffer and X Window
Date: Wed, 15 Jun 2011 22:56:40 +0200
User-Agent: KMail/1.13.5 (Linux/3.0.0-rc1; KDE/4.4.5; i686; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Florian Mickler <florian@mickler.org>
References: <9NVbY1BZ_5D.A.2lE.jzS9NB@chimera> <kTLfM29CaqB.A.P3F.a1S9NB@chimera> <20110615114614.054df25f@jbarnes-desktop>
In-Reply-To: <20110615114614.054df25f@jbarnes-desktop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201106152256.41151.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On środa, 15 czerwca 2011 o 20:46:14 Jesse Barnes wrote:
> On Sun, 12 Jun 2011 23:12:08 +0200 (CEST)
> 
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.38 and 2.6.39.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.38 and 2.6.39.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=34002
> > Subject		: [REGRESSION] [2.6.39-rc3] Wrong resolution in 
framebuffer and
> > X Window Submitter	: Maciej Rutecki <maciej.rutecki@gmail.com>
> > Date		: 2011-04-17 16:04 (57 days old)
> > Message-ID	: <201104171804.04664.maciej.rutecki@gmail.com>
> > References	: http://marc.info/?l=linux-fbdev&m=130305625114863&w=2
> 
> Did you ever bisect this issue? As Chris says it sounds like an EDID
> problem; we detect the outputs and attach some modes, but they sound
> like the wrong ones for your config.  Maybe we broke EDID fetching for
> your config?


I will try bisection at the weekend (maybe earlier if I have more free time).

Regards

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
