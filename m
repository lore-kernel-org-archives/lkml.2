Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618Ab2K1MGJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 07:06:09 -0500
Received: from ams-iport-2.cisco.com ([144.254.224.141]:2007 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754492Ab2K1MGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 07:06:07 -0500
X-Greylist: delayed 583 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Nov 2012 07:06:07 EST
X-IronPort-AV: E=McAfee;i="5400,1158,6909"; a="78637398"
From: Hans Verkuil <hansverk@cisco.com>
Organization: Cisco Systems Norway
To: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH v3 0/9] Media Controller capture driver for DM365
Date: Wed, 28 Nov 2012 12:56:10 +0100
User-Agent: KMail/1.13.7 (Linux/3.6-7.slh.1-aptosid-amd64; KDE/4.8.4; x86_64; ; )
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
        LMML <linux-media@vger.kernel.org>, devel@driverdev.osuosl.org,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Prabhakar Lad <prabhakar.lad@ti.com>,
        "Sakari Ailus" <sakari.ailus@iki.fi>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>
References: <1354099329-20722-1-git-send-email-prabhakar.lad@ti.com> <20121128114537.GN11248@mwanda>
In-Reply-To: <20121128114537.GN11248@mwanda>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201211281256.10839.hansverk@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 28 November 2012 12:45:37 Dan Carpenter wrote:
> I wish people wouldn't submit big patches right before the merge
> window opens...  :/ It's better to let it sit in linux-next for a
> couple weeks so people can mess with it a bit.

It's been under review for quite some time now, and the main change since
the last posted version is that this is now moved to staging/media.

So it is not yet ready for prime time, but we do want it in to simplify
the last remaining improvements needed to move it to drivers/media.

I'm happy with this going in given the circumstances.

Regards,

	Hans
