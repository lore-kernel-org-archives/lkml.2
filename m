Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603Ab2H2M6c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 08:58:32 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:32953 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753398Ab2H2M61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 08:58:27 -0400
Message-ID: <503E11D1.4030802@ti.com>
Date: Wed, 29 Aug 2012 18:27:53 +0530
From: Prabhakar Lad <prabhakar.lad@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: LMML <linux-media@vger.kernel.org>,
        dlos <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] media: v4l2-ctrls: add control for dpcm predictor
References: <1346243467-17094-1-git-send-email-prabhakar.lad@ti.com> <503E0E5B.2090807@samsung.com>
In-Reply-To: <503E0E5B.2090807@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sylwester,

On Wednesday 29 August 2012 06:13 PM, Sylwester Nawrocki wrote:
> Hi Prabhakar,
> 
> On 08/29/2012 02:31 PM, Prabhakar Lad wrote:
>> From: Lad, Prabhakar <prabhakar.lad@ti.com>
>>
>> add V4L2_CID_DPCM_PREDICTOR control of type menu, which
>> determines the dpcm predictor. The predictor can be either
>> simple or advanced.
> 
> Thanks for the patch. I was expecting to find some information about
> this new control in its DocBook documentation, but this part seems
> to be missing here. :) Could you please add relevant entries in
> Documentation/DocBook/media/v4l/controls.xml as well ?
> 
Thanks for the catch :) I'll add it for v2.

Thanks and Regards,
--Prabhakar

> --
> 
> Regards,
> Sylwester
> 

