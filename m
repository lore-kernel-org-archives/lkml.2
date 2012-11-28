Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824Ab2K1TaJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 14:30:09 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:38005 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508Ab2K1TaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 14:30:07 -0500
Message-id: <50B6663C.6080800@samsung.com>
Date: Wed, 28 Nov 2012 20:30:04 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Hans Verkuil <hansverk@cisco.com>, devel@driverdev.osuosl.org,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Prabhakar Lad <prabhakar.lad@ti.com>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH v3 0/9] Media Controller capture driver for DM365
References: <1354099329-20722-1-git-send-email-prabhakar.lad@ti.com>
 <20121128114537.GN11248@mwanda> <201211281256.10839.hansverk@cisco.com>
 <20121128122227.GX6186@mwanda>
In-reply-to: <20121128122227.GX6186@mwanda>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2012 01:22 PM, Dan Carpenter wrote:
> In the end this is just a driver, and I don't especially care.  But
> it's like not just this one which makes me frustrated.  I really
> believe in linux-next and I think everything should spend a couple
> weeks there before being merged.

Couple of weeks in linux-next plus a couple of weeks of final patch
series version awaiting to being reviewed and picked up by a maintainer
makes almost entire kernel development cycle. These are huge additional
delays, especially in the embedded world. Things like these certainly
aren't encouraging for moving over from out-of-tree to the mainline
development process. And in this case we are talking only about merging
driver to the staging tree...

--

Thanks,
Sylwester
