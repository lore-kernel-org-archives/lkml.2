Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933179Ab2JCP0l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 11:26:41 -0400
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50434 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932435Ab2JCP0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 11:26:40 -0400
Message-ID: <506C592C.1000304@iki.fi>
Date: Wed, 03 Oct 2012 18:26:36 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120909 Firefox/15.0.1 SeaMonkey/2.12.1
MIME-Version: 1.0
To: Prabhakar <prabhakar.csengg@gmail.com>
CC: LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        VGER <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH v5] media: mt9p031/mt9t001/mt9v032: use V4L2_CID_TEST_PATTERN
 for test pattern control
References: <1349272385-24980-1-git-send-email-prabhakar.lad@ti.com>
In-Reply-To: <1349272385-24980-1-git-send-email-prabhakar.lad@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prabhakar wrote:
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

Thanks!

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Sakari Ailus
sakari.ailus@iki.fi
