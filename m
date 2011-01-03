Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430Ab1ACQYK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 11:24:10 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:61665 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197Ab1ACQYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 11:24:08 -0500
Date: Mon, 3 Jan 2011 17:24:02 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Alberto Panizzo <maramaopercheseimorto@gmail.com>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Magnus Damm <damm@opensource.se>,
        =?ISO-8859-1?Q?M=E1rton_N=E9meth?= <nm127@freemail.hu>,
        linux-media@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] mx3_camera: Support correctly the YUV222 and BAYER
 configurations of CSI
In-Reply-To: <1294070779.2493.53.camel@realization>
Message-ID: <Pine.LNX.4.64.1101031713060.23134@axis700.grange>
References: <1290964687.3016.5.camel@realization>  <1290965045.3016.11.camel@realization>
  <Pine.LNX.4.64.1012011832430.28110@axis700.grange> <1294070779.2493.53.camel@realization>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:bOs8OYgDWgcRGEGNTg/QQb3OTfqMxMNuzMbIU2+29t6
 vmy6ZFjsMmR8SWu5lhk7s8Rvt+ATzZWnKJXR+mPWxRZ5kHTKdy
 KZQSG86ZxbnqagZeoSfhTrxntXptOLnk/FUx3B149cqPZ+fwwU
 iiU+g/Gb6V47iEjDcCu7fVi8x8EBoRJQhRXqpERdvtCY95UbYx
 mpKYfPko169kXVWKCljZvAwF0CIqukK5WUi1pVqUMk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Jan 2011, Alberto Panizzo wrote:

[snip]

> Guennadi, how do you consider the path I've shown? Can I continue in this
> way or shall I present a patch that get rid of translations and manage
> all the pixel format in the way I understood the manual speak about?
> 
> I prefer this way that maintain the usability of the whole set of pixel codes
> for everyone after this step and then fix together the translations. 
> I don't hold a camera that output a grey format..

Sorry, I'm not sure I understand what exactly you're proposing. Please, 
just look at my last reply, in which I explain, why I don't think this is 
a good way to fix things. You don't need to support various formats 
natively on CSI / IPU to be able to just pass data 1-to-1. If that is your 
only purpose, please, test it that way, and if it is broken, please, fix 
it. This would be good even if you actually want to support formats 
natively eventually, because that would also fix other formats with 
similar sample-per-pixel values. When this is fixed, if you want to 
actually support formats natively to perform some hardware-assisted format 
conversions, that also can be done, but then, please, explain this clearly 
in your patch (series).

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
