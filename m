Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127Ab1K3GV0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 01:21:26 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:47605 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752314Ab1K3GVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 01:21:25 -0500
X-Sasl-enc: 5zccWjDPNbJ+ww55i1SR578PsSq+/OkmzP1fMOMAVIvH 1322634083
Date: Wed, 30 Nov 2011 15:21:04 +0900
From: Greg KH <greg@kroah.com>
To: Federico Vaga <federico.vaga@gmail.com>
Cc: Alessandro Rubini <rubini@gnudd.com>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, dcobas@cern.ch, siglesia@cern.ch,
        manohar.vanga@cern.ch
Subject: Re: [RFC PATCH 2/7] include/linux: add headers for drivers/zio
Message-ID: <20111130062104.GA11393@kroah.com>
References: <cover.1322328073.git.rubini@gnudd.com>
 <09c2b3834c06fc45d8cca26d980482c8dad7af5a.1322328075.git.rubini@gnudd.com>
 <20111126200216.GC11421@kroah.com>
 <1491684.cGqJrVR8Lo@harkonnen>
 <20111127093224.GB31086@kroah.com>
 <CAH5GJ0o_T3DpZ=AK5dsDjQobes2KRF4uVyyr-HxzA6tri_AYoA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH5GJ0o_T3DpZ=AK5dsDjQobes2KRF4uVyyr-HxzA6tri_AYoA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 03:56:45PM +0100, Federico Vaga wrote:
> I don't reply to each point because I suppose the point is: "kobject
> or device for sysfs?", maybe I misunderstood.

That is correct.

> I know that it is not a good thing reply with a new question, but I
> think it can clarify the problem.
> 
> Why device is it preferred to export some sysfs attributes when sysfs
> ask me kobject?

If your code is working properly, you don't have to ever make sysfs
calls, only driver core calls, for sysfs files.  There might be a few
minor exceptions, but I think the coverage is all there now.

> As I tested both device and kobject, I'll do a parallel implementation
> with device.

As you are using a tree of devices, please use struct device, I can't
accept the code otherwise.

greg k-h
