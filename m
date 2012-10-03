Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197Ab2JCONJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 10:13:09 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:52562 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479Ab2JCONH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 10:13:07 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: davinci-linux-open-source@linux.davincidsp.com
Cc: Prabhakar <prabhakar.csengg@gmail.com>, LMML <linux-media@vger.kernel.org>,
        VGER <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Sakari Ailus <sakari.ailus@iki.fi>, Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH v5] media: mt9p031/mt9t001/mt9v032: use V4L2_CID_TEST_PATTERN for test pattern control
Date: Wed, 03 Oct 2012 16:13:47 +0200
Message-ID: <2224867.hMfXSgyTsI@avalon>
User-Agent: KMail/4.9.2 (Linux/3.4.9-gentoo; KDE/4.9.2; x86_64; ; )
In-Reply-To: <1349272385-24980-1-git-send-email-prabhakar.lad@ti.com>
References: <1349272385-24980-1-git-send-email-prabhakar.lad@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prabhakar,

On Wednesday 03 October 2012 19:23:05 Prabhakar wrote:
> From: Lad, Prabhakar <prabhakar.lad@ti.com>
> 
> V4L2_CID_TEST_PATTERN is now a standard control.
> This patch replaces the user defined control for test
> pattern to make use of standard control V4L2_CID_TEST_PATTERN.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Sakari Ailus <sakari.ailus@iki.fi>
> Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
> Cc: Jean Delvare <khali@linux-fr.org>

Should I push this patch through my tree ? If so I'll wait until the 
V4L2_CID_TEST_PATTERN control patch hits Mauro's tree.

-- 
Regards,

Laurent Pinchart

