Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885Ab2K3J4I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 04:56:08 -0500
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2590 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479Ab2K3J4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 04:56:05 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH v3 0/9] Media Controller capture driver for DM365
Date: Fri, 30 Nov 2012 10:54:36 +0100
User-Agent: KMail/1.13.7 (Linux/3.7.0-rc1-tschai; KDE/4.8.4; x86_64; ; )
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
        LMML <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Prabhakar Lad <prabhakar.lad@ti.com>, devel@driverdev.osuosl.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
References: <1354099329-20722-1-git-send-email-prabhakar.lad@ti.com> <20121130094739.GJ31879@valkosipuli.retiisi.org.uk>
In-Reply-To: <20121130094739.GJ31879@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201211301054.36334.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri November 30 2012 10:47:39 Sakari Ailus wrote:
> On Wed, Nov 28, 2012 at 04:12:00PM +0530, Prabhakar Lad wrote:
> > From: Manjunath Hadli <manjunath.hadli@ti.com>
> > 
> > Mauro/Greg,
> >  The below series of patches have gone through good amount of reviews, and
> > agreed by Laurent, Hans and Sakari to be part of the staging tree. I am combining
> > the patchs with the pull request so we can get them into the 3.8 kernel.
> > Please pull these patches.If you want a seperate pull request, please let me
> > know.
> > 
> > This patch set adds media controller based capture driver for
> > DM365.
> 
> For the whole set --- granted that the TODO item to "add support for regular
> V4L2 applications through user space libraries" is added:
> 
> Acked-by: Sakari Ailus <sakari.ailus@iki.fi>
> 
> 

Ditto for the TODO item.

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
