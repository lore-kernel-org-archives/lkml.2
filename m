Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188Ab2K2QjE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 11:39:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56395 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846Ab2K2QjB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 11:39:01 -0500
Date: Thu, 29 Nov 2012 14:38:38 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Manjunath Hadli <manjunath.hadli@ti.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <devel@driverdev.osuosl.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Prabhakar Lad <prabhakar.lad@ti.com>,
        Hans Verkuil <hansverk@cisco.com>, Sakari Ailus <sakari.ailus@iki.fi>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH v3 0/9] Media Controller capture driver for DM365
Message-ID: <20121129143838.01604378@redhat.com>
In-Reply-To: <50B758F3.5060008@ti.com>
References: <1354099329-20722-1-git-send-email-prabhakar.lad@ti.com>
	<201211282018.20832.hverkuil@xs4all.nl>
	<20121128193021.GA4174@kroah.com>
	<201211290843.36468.hverkuil@xs4all.nl>
	<20121129083956.227f55ee@redhat.com>
	<50B758F3.5060008@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, 29 Nov 2012 18:15:39 +0530
Manjunath Hadli <manjunath.hadli@ti.com> escreveu:

> > So, in summary:
> > 
> > Prabhakar/Manju:
> > 
> > If you'll be committed to make sure that no regressions will happen when this
> > driver will be promoted and replace the existing driver, please update
> > the TODO to point that the compatibility bits is needed.
> Sure Mauro. All this long wait to get into the mainline would be for
> nothing if we do not go ahead and make the necessary changes you want us
> to do to get to the media folder. We will update the TODO patch and
> resend the series.

Ok, thank you!

Regards,
Mauro
