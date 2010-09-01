Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836Ab0IAUak (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 16:30:40 -0400
Received: from smtp101.vzn.mail.re1.yahoo.com ([69.147.103.188]:25563 "HELO
	smtp101.vzn.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752145Ab0IAUaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 16:30:39 -0400
X-Greylist: delayed 2903 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Sep 2010 16:30:39 EDT
X-Yahoo-SMTP: fqWQs0mswBBtcNE4XkkshIohcKqpeDUh8nXJG.biWOZq
X-YMail-OSG: WQzD.c4VM1nCIAfubeSipYX201Fu_xxMIMHi7N0oKgkAWgj
 zT81SUGLE2Q0QoTkd_wSi26y7n3c7GF7fZApTmeddVaRKSH_dZc9_W_FmCgt
 DhLAD6Ttzm8cP_UfY0AaNUf2qTODZHxqZsfSov9y2OTmcEJlale1lFbMqH3A
 3.kkVmg8DoCjQztcGhqWCG0i.7Za9ZrKtneu1OYDFpAJtsiQkoOGfEAXRVDC
 5IwxMSmLKYgfusJ9b_RunfJ.BpE2VeTeuc90vxffPdNcW0uTtL1BRgVxInQn
 vinyZCDOubRB.25oWCYBy377LQ4r0.x5zF1Guqn8A4jZV6ZRFUuA.XZAe6NP
 9HvkBpH521sMVZZleetYQ90KyH006C5g__2ptoJx6dxpMP9TbUPdCCClT.1j
 thbRg9TbM
X-Yahoo-Newman-Property: ymail-3
From: Johan Kullstam <kullstj_ml@verizon.net>
To: linux-kernel@vger.kernel.org
Subject: Re: [Bug #16515] Radeon rv280 can't boot on kernel 2.6.35.
Organization: none
References: <c1_O4wHrlB.A.63.mbueMB@chimera>
	<ByD_7B96czP.A.d0B.4cueMB@chimera>
Date: Wed, 01 Sep 2010 15:42:11 -0400
In-Reply-To: <ByD_7B96czP.A.d0B.4cueMB@chimera> (Rafael J. Wysocki's message
	of "Mon, 30 Aug 2010 01:13:33 +0200 (CEST)")
Message-ID: <8762ypi73g.fsf@emmy.axel.nom>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.34 and 2.6.35.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.34 and 2.6.35.  Please verify if it still should
> be listed and let the tracking team know (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16515
> Subject		: Radeon rv280 can't boot on kernel 2.6.35.
> Submitter	: Albert Gall <ss3vdr@gmail.com>
> Date		: 2010-08-04 16:10 (26 days old)
> Handled-By	: Alex Deucher <alexdeucher@gmail.com>

This bug was introduced with 2.6.35-rc1 and continues through
2.6.36-rc3.  It is still a bug.  I cannot boot with modeset=1 on DVI
port (not sure about VGA port status).

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Johan KULLSTAM
