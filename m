Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab0IVCz5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 22:55:57 -0400
Received: from smtp102.vzn.mail.re1.yahoo.com ([69.147.103.189]:33376 "HELO
	smtp102.vzn.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752643Ab0IVCz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 22:55:56 -0400
X-Yahoo-SMTP: fqWQs0mswBBtcNE4XkkshIohcKqpeDUh8nXJG.biWOZq
X-YMail-OSG: 1ctDs7UVM1lmZ5M0qOA241xAWYphCL.VyFFuo2m3yhFtSoE
 s1f3s_0NBioN55.JRSYEgBIEswRYDhwc3QZNsYbvu3cZkl_KKs5dIQLDz.CU
 5OnnDeOJvC_6Any1cM9JDiX_hwb77yDoJUUg_ZheBaLa3HUJTlcJGLM2PwHC
 SW9.zc1kmQy9dW5eE0lg5oD2klaBXF7dbLBzwMv9GtxYxLRrGCDUH2cFpC5q
 qU4Pn_T9LAMJMkgy8kypwIyhk.zEuo7fBGWu6P8hQqT6ozUe51MVD85WELLB
 lAJPUwMQbZSkYP8Rr5Xfrj4J3YEzRipa3TONQLYARmQ6Y6eZscaW61gnXTDe
 eh.DPvj.U29t4RTJOMoVgp9LOHTNCzWby7VMO4wvGhqhlmZTqdZ3WBZ84vCB
 zv3CF9QoK
X-Yahoo-Newman-Property: ymail-3
From: Johan Kullstam <kullstj_ml@verizon.net>
To: linux-kernel@vger.kernel.org
Subject: Re: [Bug #16515] [bisected] Radeon rv280 can't boot on kernel 2.6.35.
Organization: none
References: <r2gGqgg1zFC.A.LrE.w97lMB@chimera>
	<aRnAGz9xZ8K.A.P4F.D_7lMB@chimera>
Date: Tue, 21 Sep 2010 22:55:53 -0400
In-Reply-To: <aRnAGz9xZ8K.A.P4F.D_7lMB@chimera> (Rafael J. Wysocki's message
	of "Mon, 20 Sep 2010 21:57:18 +0200 (CEST)")
Message-ID: <87tyli4hc6.fsf@emmy.axel.nom>
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

Please keep this listed.  As of 2.6.36-rc5 this bug is still with us.
It was introduced in 2.6.35-rc1.  The 2.6.34.7 kernel is fine.

Monitor is on the DVI port.  Once I load the module radeon with
modeset=1, the machine locks hard.  There are no logs.

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16515
> Subject		: [bisected] Radeon rv280 can't boot on kernel 2.6.35.
> Submitter	: Albert Gall <ss3vdr@gmail.com>
> Date		: 2010-08-04 16:10 (48 days old)
> First-Bad-Commit: http://git.kernel.org/linus/https://bugzilla.kernel.org/attachment.cgi?id=27350
> Handled-By	: Alex Deucher <alexdeucher@gmail.com>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Johan KULLSTAM
