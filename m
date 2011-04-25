Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758381Ab1DYOEO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 10:04:14 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:62873 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756714Ab1DYOEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 10:04:13 -0400
Message-ID: <4DB57F62.4020507@web.de>
Date: Mon, 25 Apr 2011 16:04:18 +0200
From: =?ISO-8859-1?Q?J=F6rg-Volker_Peetz?= <jvpeetz@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110402 Icedove/3.1.9
MIME-Version: 1.0
To: "Ostrovsky, Boris" <Boris.Ostrovsky@amd.com>
CC: Borislav Petkov <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "Petkov, Borislav" <Borislav.Petkov@amd.com>
Subject: Re: Linux 2.6.38.4 : regression due to x86 AMD ARAT feature
References: <20110421213926.GA19721@kroah.com> <4DB3DA0C.1050003@web.de> <20110424182041.GA19984@liondog.tnic>,<4DB47211.90901@dynato-kyma.net> <EE335F95F28A664DB4A21289D2AA053BD1807651@SAUSEXMBP01.amd.com>
In-Reply-To: <EE335F95F28A664DB4A21289D2AA053BD1807651@SAUSEXMBP01.amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Provags-ID: V02:K0:w+Bb/sA8Llq1Dn+5ieshyD6oLRTXk62EMKONMbJHMzi
 pCE4EE+BiuqmdZ56iyKzQYCpDy91K4V968ZQ8mWPQOwLGrqli3
 sYt6/WpRvH4VukYr380iCvtPb4hLtcMLnQ/zdPAMRo4Gt9XO8W
 +gVWS0+o8YfUNkrrQJBL0sML6wOsxqs3R3mv9inEg9SAJnX9LF
 i/Z4+F5Qca+Bb80faWvLg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you very much for caring.
-- 
Best regards,
Jörg-Volker.

Ostrovsky, Boris wrote, on 04/24/11 21:44:
> It's an old family fh processor (CPUID 00020F42) that cpu_has_amd_erratum(amd_erratum_400) apparently hasn't picked up. Since all fh processors are affected by this erratum I'll replace "c->x86 >= 0xf" with "c->x86 > 0xf" (and probably fix erratum formula anyway).
> 
> -boris
<snip>
