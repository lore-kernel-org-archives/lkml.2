Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316Ab2JCJGP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 05:06:15 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:49944 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845Ab2JCJGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 05:06:13 -0400
Message-ID: <506BFFFB.5050103@ti.com>
Date: Wed, 3 Oct 2012 14:36:03 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Prabhakar <prabhakar.csengg@gmail.com>
CC: LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        VGER <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] davinci: vpbe: replace V4L2_OUT_CAP_CUSTOM_TIMINGS with
 V4L2_OUT_CAP_DV_TIMINGS
References: <1349245973-7377-1-git-send-email-prabhakar.lad@ti.com>
In-Reply-To: <1349245973-7377-1-git-send-email-prabhakar.lad@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/3/2012 12:02 PM, Prabhakar wrote:
> From: Lad, Prabhakar <prabhakar.lad@ti.com>
> 
> This patch replaces V4L2_OUT_CAP_CUSTOM_TIMINGS macro with
> V4L2_OUT_CAP_DV_TIMINGS. As V4L2_OUT_CAP_CUSTOM_TIMINGS is being phased
> out.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> Cc: Sekhar Nori <nsekhar@ti.com>
> Cc: Hans Verkuil <hansverk@cisco.com>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>

For the DaVinci platform change:

Acked-by: Sekhar Nori <nsekhar@ti.com>

Thanks,
Sekhar
