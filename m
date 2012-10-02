Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab2JBItj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 04:49:39 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:44960 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076Ab2JBItf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 04:49:35 -0400
Message-ID: <506AAA7B.1020308@ti.com>
Date: Tue, 2 Oct 2012 14:18:59 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Prabhakar <prabhakar.csengg@gmail.com>
CC: LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        VGER <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH v3] media: davinci: vpif: display: separate out subdev
 from output
References: <1348571509-4131-1-git-send-email-prabhakar.lad@ti.com>
In-Reply-To: <1348571509-4131-1-git-send-email-prabhakar.lad@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/25/2012 4:41 PM, Prabhakar wrote:
> From: Lad, Prabhakar <prabhakar.lad@ti.com>
> 
> vpif_display relied on a 1-1 mapping of output and subdev. This is not
> necessarily the case. Separate the two. So there is a list of subdevs
> and a list of outputs. Each output refers to a subdev and has routing
> information. An output does not have to have a subdev.
> 
> The initial output for each channel is set to the fist output.
> 
> Currently missing is support for associating multiple subdevs with
> an output.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Sekhar Nori <nsekhar@ti.com>

For the DaVinci platform changes:

Acked-by: Sekhar Nori <nsekhar@ti.com>

Thanks,
Sekhar
