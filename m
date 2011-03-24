Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796Ab1CXLSj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 07:18:39 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:34366 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840Ab1CXLSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 07:18:37 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4D8B28D9.2010102@cam.ac.uk>
Date: Thu, 24 Mar 2011 11:19:53 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110122 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: cliff.cai@analog.com
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        drivers@analog.com, device-drivers-devel@blackfin.uclinux.org
Subject: Re: [PATCH 1/2 RESEND v4] IIO driver for Analog Devices Digital Output
 Gyroscope ADXRS450
References: <1300946583-1715-1-git-send-email-cliff.cai@analog.com>
In-Reply-To: <1300946583-1715-1-git-send-email-cliff.cai@analog.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/11 06:03, cliff.cai@analog.com wrote:
> From: Cliff Cai <cliff.cai@analog.com>
> 
> Change v4:v3:
> 	clean up some nitpicks.
I acked the last version and there have been no major
changes so you should have added that below for this
posting. Same is true of the next patch.

Please add them to your commit messages, respin the
patches series and send on to Greg KH for a merge.
I think you've just missed this merge window so it will
sit in staging-next until the next one opens.

Thanks,
> 
> Signed-off-by: Cliff Cai <cliff.cai@analog.com>
Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
