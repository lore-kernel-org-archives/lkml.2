Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292Ab0GAHi6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 03:38:58 -0400
Received: from smtp.nokia.com ([192.100.122.233]:30705 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187Ab0GAHi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 03:38:57 -0400
Date: Thu, 1 Jul 2010 10:35:23 +0300
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Christoph Egger <siccegge@cs.fau.de>
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
       Paul Walmsley <paul@pwsan.com>, Kalle Valo <kalle.valo@iki.fi>,
       Santosh Shilimkar <santosh.shilimkar@ti.com>,
       Ladislav Michl <ladis@linux-mips.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "vamos@i4.informatik.uni-erlangen.de" 
	<vamos@i4.informatik.uni-erlangen.de>
Subject: Re: [PATCH 20/33] Removing dead MACH_OMAP2_H4_USB1
Message-ID: <20100701073523.GT3843@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <cover.1277911345.git.siccegge@cs.fau.de>
 <24b01f2edebd09e37306c35f14401819d8219549.1277911346.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <24b01f2edebd09e37306c35f14401819d8219549.1277911346.git.siccegge@cs.fau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 01 Jul 2010 07:38:11.0664 (UTC) FILETIME=[5B81C500:01CB18F0]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 30, 2010 at 06:00:23PM +0200, ext Christoph Egger wrote:
>MACH_OMAP2_H4_USB1 doesn't exist in Kconfig, therefore removing all
>references for it from the source code.
>
>Signed-off-by: Christoph Egger <siccegge@cs.fau.de>

Does this apply on top of Tony's recent patches ??

-- 
balbi

DefectiveByDesign.org
