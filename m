Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058Ab1F0HPn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 03:15:43 -0400
Received: from alice.et.bocholt.fh-gelsenkirchen.de ([193.175.197.63]:35763
	"EHLO alice.et.bocholt.fh-gelsenkirchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756536Ab1F0HO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 03:14:58 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 alice.et.bocholt.fh-gelsenkirchen.de p5R7EIqo018707
From: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, "Robse" <rob-se@live.de>
Subject: Re: [Bug #37472] Lenovo U160 (i915 black screen)
In-Reply-To: <Rm1pgFxEGUF.A.YXE.hM7BOB@chimera> (Rafael J. Wysocki's message
	of "Mon, 27 Jun 2011 00:35:14 +0200 (CEST)")
References: <fvHbBUhG0PD.A.IGE.HM7BOB@chimera>
	<Rm1pgFxEGUF.A.YXE.hM7BOB@chimera>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
Date: Mon, 27 Jun 2011 09:14:17 +0200
Message-ID: <giy60nn3ue.fsf@mx10.gouders.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Greylist: Sender succeeded STARTTLS authentication, not delayed by milter-greylist-4.2.3 (alice.et.bocholt.fh-gelsenkirchen.de [192.168.0.63]); Mon, 27 Jun 2011 09:14:19 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> The following bug entry is on the current list of known regressions
> introduced between 2.6.38 and 2.6.39.  Please verify if it still should
> be listed and let the tracking team know (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=37472
> Subject		: Lenovo U160 (i915 black screen)
> Submitter	: Robse <rob-se@live.de>
> Date		: 2011-06-14 15:17 (13 days old)

This sounds like a problem, I was discussing with Jesse Barnes, some
days ago[1].  For me, the usage of the kernel parameter
'i915.lvds_use_ssc=0' serves as a useful workaround.

Perhaps, Robse will try that option and document it in the Bug-Entry if
it also works for him.

Dirk

[1] https://lkml.org/lkml/2011/5/31/387
