Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947Ab1AUJaj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 04:30:39 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33363 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750844Ab1AUJah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 04:30:37 -0500
Date: Fri, 21 Jan 2011 01:30:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Hennerich, Michael" <Michael.Hennerich@analog.com>
Cc: Mike Frysinger <vapier@gentoo.org>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH] backlight: new driver for the ADP8870 backlight devices
Message-Id: <20110121013013.076a0fed.akpm@linux-foundation.org>
In-Reply-To: <544AC56F16B56944AEC3BD4E3D591771324C0A8C6F@LIMKCMBX1.ad.analog.com>
References: <1294794049-17337-1-git-send-email-vapier@gentoo.org>
	<20110120164816.5afa0561.akpm@linux-foundation.org>
	<544AC56F16B56944AEC3BD4E3D591771324C0A8C6F@LIMKCMBX1.ad.analog.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Jan 2011 09:25:50 +0000 "Hennerich, Michael" <Michael.Hennerich@analog.com> wrote:

> > Is the sysfs API documented anywhere?
> 
> Yes - http://wiki-analog.com/software/driver/linux/adp8870
> I guess you are asking me to write something that goes into linux-2.6.x/Documentation?

That would be nice, please.  Documentation/ABI/, perhaps.

In an ideal world, documentation wouldn't be necessary because all
backlight drivers offer the same (or sufficiently similar) interfaces,
so one generic document describes them all.  I don't know how close
we are to that however.

