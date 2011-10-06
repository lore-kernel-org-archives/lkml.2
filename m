Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935833Ab1JFLcP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 07:32:15 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:55986 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935288Ab1JFLcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 07:32:14 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E8D93B7.4010802@cam.ac.uk>
Date: Thu, 06 Oct 2011 12:40:39 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110930 Thunderbird/6.0.2
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: greg@kroah.com, Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] drivercore: Add helper macro for platform_driver boilerplate
References: <20111004232403.10364.22050.stgit@ponder>
In-Reply-To: <20111004232403.10364.22050.stgit@ponder>
X-Enigmail-Version: 1.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/11 00:26, Grant Likely wrote:
> For simple modules that contain a single platform_driver without any
> additional setup code then ends up being a block of duplicated
> boilerplate.  This patch adds a new macro, module_platform_driver(),
> which replaces the module_init()/module_exit() registrations with
> template functions.
> 
> This patch also converts all the relevant spi drivers to use the new
> macro.  There are a lot of drivers in the tree that are using this
> pattern and could be converted.
> 
> It also fixes up some incorrect section annotations where I found
> them.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> ---
> 
> I think this is useful, and I like the diffstat that it produces.
> What does everyone else think of this approach?  I can do versions for
> i2c_drivers and spi_drivers too.
Excellent idea.  Great to shrink this boilerplate where ever you can.
i2c and spi version would be excellent.  Look to be 426 instances
(I haven't checked but most are of the standard trivial form). So that is
another few thousand lines gone. It's getting on for 500 in IIO alone where
they are all of the trivial form, so this will make me very happy :)

Thanks Grant!

Jonathan
