Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626Ab1LWKeD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 05:34:03 -0500
Received: from fep27.mx.upcmail.net ([62.179.121.47]:61527 "EHLO
	fep27.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906Ab1LWKeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 05:34:00 -0500
X-SourceIP: 178.83.228.246
X-Authenticated-Sender: odi.ch@hispeed.ch
Message-ID: <4EF458CD.90300@odi.ch>
Date: Fri, 23 Dec 2011 11:32:45 +0100
From: =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: DMAR log spam
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

3.2-rc6 with INTEL_IOMMU and INTEL_IOMMU_DEFAULT_ON fills the log with 
these lines after starting X with the proprietariy nvidia driver. The 
system becomes unusable after that (appears frozen but I guess it's just 
too busy writing this log).

Ortwin

Dec 23 11:20:43 ortwin-hp kernel: DMAR:[fault reason 02] Present bit in 
context entry is clear
Dec 23 11:20:43 ortwin-hp kernel: DRHD: handling fault status reg 2
Dec 23 11:20:43 ortwin-hp kernel: DMAR:[DMA Read] Request device 
[01:00.0] fault addr 22e2a1000
Dec 23 11:20:43 ortwin-hp kernel: DMAR:[fault reason 02] Present bit in 
context entry is clear
Dec 23 11:20:43 ortwin-hp kernel: DRHD: handling fault status reg 2
Dec 23 11:20:43 ortwin-hp kernel: DMAR:[DMA Read] Request device 
[01:00.0] fault addr 22e2a1000
Dec 23 11:20:43 ortwin-hp kernel: DMAR:[fault reason 02] Present bit in 
context entry is clear
Dec 23 11:20:43 ortwin-hp kernel: DRHD: handling fault status reg 2
Dec 23 11:20:43 ortwin-hp kernel: DMAR:[DMA Read] Request device 
[01:00.0] fault addr 22e2a1000
Dec 23 11:20:43 ortwin-hp kernel: DMAR:[fault reason 02] Present bit in 
context entry is clear
Dec 23 11:20:43 ortwin-hp kernel: DRHD: handling fault status reg 2
Dec 23 11:20:43 ortwin-hp kernel: DMAR:[DMA Read] Request device 
[01:00.0] fault addr 22e2a1000
Dec 23 11:20:43 ortwin-hp kernel: DMAR:[fault reason 02] Present bit in 
context entry is clear
Dec 23 11:20:43 ortwin-hp kernel: DRHD: handling fault status reg 2
Dec 23 11:20:43 ortwin-hp kernel: DMAR:[DMA Read] Request device 
[01:00.0] fault addr 22e2a1000
Dec 23 11:20:43 ortwin-hp kernel: DMAR:[fault reason 02] Present bit in 
context entry is clear
Dec 23 11:20:43 ortwin-hp kernel: DRHD: handling fault status reg 2
Dec 23 11:20:43 ortwin-hp kernel: DMAR:[DMA Read] Request device 
[01:00.0] fault addr 22e2a1000
Dec 23 11:20:43 ortwin-hp kernel: DMAR:[fault reason 02] Present bit in 
context entry is clear
Dec 23 11:20:43 ortwin-hp kernel: DRHD: handling fault status reg 2

