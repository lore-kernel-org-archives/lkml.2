Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab0IVUQt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 16:16:49 -0400
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:25492 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751298Ab0IVUQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 16:16:48 -0400
Subject: Re: [PATCH] drm/sysfs: Provide per connector control of DRM KMS
 polling
From: Andy Walls <awalls@md.metrocast.net>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        Dave Airlie <airlied@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Jon Smirl <jonsmirl@gmail.com>
In-Reply-To: <1285158711.2731.42.camel@morgan.silverblock.net>
References: <1284987540.2242.29.camel@morgan.silverblock.net>
	 <AANLkTikj4biBS7wQsRM6o3kEmyaPNMaSUBEktMmmOy89@mail.gmail.com>
	 <1285023750.30856.99.camel@morgan.silverblock.net>
	 <AANLkTi=RCJcQMSWMm6pQgJnJZT9TyfGyFtWmeu8GKHA-@mail.gmail.com>
	 <1285090202.19131.77.camel@morgan.silverblock.net>
	 <AANLkTi=h=9mvdLMcZZAtg3_eu7wD2Yj0Dn2iWjhF7BiL@mail.gmail.com>
	 <1285158711.2731.42.camel@morgan.silverblock.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Sep 2010 16:16:37 -0400
Message-ID: <1285186597.14364.4.camel@morgan.silverblock.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.0.10011,1.0.148,0.0.0000
 definitions=2010-09-22_10:2010-09-22,2010-09-22,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 phishscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1005130000 definitions=main-1009220181
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-22 at 08:31 -0400, Andy Walls wrote:
> On Wed, 2010-09-22 at 01:30 -0400, Alex Deucher wrote:

> > It appears to be incorrect.  If you send me a copy of the vbios, I can
> > easily add a quirk. I suspect your board oem may offer several boards
> > with different output configurations and neglected to update the table
> > in some configurations.
> 
> Do you have a pointer to a set of steps to follow for extracting that
> vbios information?

Never mind, I figured it out.

# echo 1 > /sys/class/drm/card0/device/rom
# dd if=/sys/class/drm/card0/device/rom of=msi7302igprom.bin
# echo 0 > /sys/class/drm/card0/device/rom

I will send it via private email.

Regards,
Andy


