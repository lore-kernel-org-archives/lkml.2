Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757021Ab0ITVMG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 17:12:06 -0400
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:51015 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754983Ab0ITVME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 17:12:04 -0400
Subject: Re: [PATCH] drm/sysfs: Provide per connector control of DRM KMS
 polling
From: Andy Walls <awalls@md.metrocast.net>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Dave Airlie <airlied@redhat.com>, Jon Smirl <jonsmirl@gmail.com>
In-Reply-To: <20100920185232.GA29263@kroah.com>
References: <1284987540.2242.29.camel@morgan.silverblock.net>
	 <20100920185232.GA29263@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Sep 2010 17:11:48 -0400
Message-ID: <1285017108.30856.7.camel@morgan.silverblock.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.0.10011,1.0.148,0.0.0000
 definitions=2010-09-20_11:2010-09-20,2010-09-20,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 phishscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1005130000 definitions=main-1009200123
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-20 at 11:52 -0700, Greg KH wrote:
> On Mon, Sep 20, 2010 at 08:59:00AM -0400, Andy Walls wrote:
 
> > This change allows the root user to disable (and re-enable) DRM KMS
> > connector polling on a per connector basis via sysfs, like so:
> > 
> >         # cat /sys/class/drm/card0/card0-DVI-D-1/polled
> >         [hotplug_detectable] connect disconnect

> You are adding a sysfs file, yet you forgot to add a file in
> Documentation/ABI.  Please fix that and resend the patch.

Oops, process failure, sorry.
Will do.

Regards,
Andy

