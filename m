Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867Ab2DWOwN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 10:52:13 -0400
Received: from queueout02-winn.ispmail.ntl.com ([81.103.221.56]:12041 "EHLO
	queueout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751812Ab2DWOwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 10:52:12 -0400
Message-ID: <4F9545FF.8050502@blueyonder.co.uk>
Date: Mon, 23 Apr 2012 13:07:27 +0100
From: Sid Boyce <sboyce@blueyonder.co.uk>
Reply-To: sboyce@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: LKML Mailing List <linux-kernel@vger.kernel.org>,
        opensuse factory list <opensuse-factory@opensuse.org>
Subject: Recent hardware incompatibilities
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.1 cv=JvdXmxIgLJv2/GthKqHpGJEEHukvLcvELVXUanXFreg= c=1 sm=0 a=5XsFQGJ3Uf0A:10 a=3NElcqgl2aoA:10 a=k1j_C7plYBUA:10 a=8nJEP1OIZ-IA:10 a=HHGDmE7w67jggAgikYAA:9 a=wPNLvfGTeEIA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently I have tried using Asus Sabertooth 990FX and Gigabyte 990FX 
motherboards and experienced problems.

They both need IOMMU disabled in the BIOS in order to boot.

The Sabertooth will work with the nouveau driver but the proprietary 
NVidia driver won't work as the NVidia card is detected as a AMD Radeon. 
I learned later that the Sabertooth BIOS says Windows, other boards have 
Windows and Other OS's support.
I took this up with the Asus Tech Support dummies but they seemed like 
dumb dummies rather than smart dummies (Tm Amdahl).

The Gigabyte board works with both the nouveau and the proprietary 
NVidia driver.

I suspect these quirks are due to incompatibilities in the BIOS for 
these new motherboards.

Any comments or recommendations on Linux compatible motherboards with 
modern chipsets.

Intel a better solution that AMD perhaps?
Regards
Sid.

-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Senior Staff Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

