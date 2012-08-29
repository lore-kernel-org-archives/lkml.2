Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab2H2MnM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 08:43:12 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:20915 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab2H2MnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 08:43:10 -0400
Message-id: <503E0E5B.2090807@samsung.com>
Date: Wed, 29 Aug 2012 14:43:07 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430
 Thunderbird/12.0.1
MIME-version: 1.0
To: Prabhakar Lad <prabhakar.lad@ti.com>
Cc: LMML <linux-media@vger.kernel.org>,
        dlos <davinci-linux-open-source@linux.davincidsp.com>,
        linux-kernel@vger.kernel.org, Manjunath Hadli <manjunath.hadli@ti.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] media: v4l2-ctrls: add control for dpcm predictor
References: <1346243467-17094-1-git-send-email-prabhakar.lad@ti.com>
In-reply-to: <1346243467-17094-1-git-send-email-prabhakar.lad@ti.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prabhakar,

On 08/29/2012 02:31 PM, Prabhakar Lad wrote:
> From: Lad, Prabhakar <prabhakar.lad@ti.com>
> 
> add V4L2_CID_DPCM_PREDICTOR control of type menu, which
> determines the dpcm predictor. The predictor can be either
> simple or advanced.

Thanks for the patch. I was expecting to find some information about
this new control in its DocBook documentation, but this part seems
to be missing here. :) Could you please add relevant entries in
Documentation/DocBook/media/v4l/controls.xml as well ?

--

Regards,
Sylwester
