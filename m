Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911Ab0KSJnM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 04:43:12 -0500
Received: from smtprelay03.ispgateway.de ([80.67.31.30]:36632 "EHLO
	smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279Ab0KSJnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 04:43:10 -0500
Message-ID: <4CE64668.1060803@ladisch.de>
Date: Fri, 19 Nov 2010 10:42:00 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Gene Heskett <gene.heskett@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Missing nvidia.ko, cannot install nvidia driver
References: <201011182208.00077.gene.heskett@gmail.com>
In-Reply-To: <201011182208.00077.gene.heskett@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gene Heskett wrote:
> All of a sudden it seems I cannot find the option that makes a kernel build
> include the build and install of
> /lib/modules/2.6.36/kernel/drivers/video/nvidia.ko

There is no option for that module, neither in 2.6.33 nor in 2.6.36,
because that module is not part of any kernel from kernel.org.

Nvidia's closed-source driver is evil, so do *not* click on this link:
http://www.nvidia.com/object/unix.html


Regards,
Clemens
