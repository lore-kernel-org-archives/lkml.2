Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414Ab1HCK1r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 06:27:47 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:43685 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120Ab1HCK1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 06:27:36 -0400
Date: Wed, 3 Aug 2011 13:25:30 +0300
From: Dan Carpenter <error27@gmail.com>
To: Ravishnakar <ravishankarkm32@gmail.com>
Cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>
Subject: Re: [PATCH v2] Staging: comedi: fix warning issue in pcl818.c
Message-ID: <20110803102530.GH3839@shale.localdomain>
References: <1312358559-5674-1-git-send-email-ravishankarkm32@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312358559-5674-1-git-send-email-ravishankarkm32@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You're still putting KERNEL_WARNING labels in the middle of the
printed output instead of only at the start of the line.

regards,
dan carpenter
