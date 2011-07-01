Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873Ab1GAJAe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 05:00:34 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:39869 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755516Ab1GAJAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 05:00:33 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E0D8E94.5030604@cam.ac.uk>
Date: Fri, 01 Jul 2011 10:08:36 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110509 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Nathan Royer <nroyer@invensense.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Jiri Kosina <jkosina@suse.cz>,
        Alan Cox <alan@linux.intel.com>, Jean Delvare <khali@linux-fr.org>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 01/11] misc: inv_mpu primary header file and README file.
References: <1309486707-1658-1-git-send-email-nroyer@invensense.com>
In-Reply-To: <1309486707-1658-1-git-send-email-nroyer@invensense.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/11 03:18, Nathan Royer wrote:
> This files defines the userspace interface and how to integrate it into a
> platform.
> 
> Signed-off-by: Nathan Royer <nroyer@invensense.com>
> ---
> 
> This is the first of many patch files for the inv_mpu driver in its current
> state.  This is our first time submitting this driver, so I expect there to be
> a lot wrong with it, and expect to need to fix many things.
Just out of interest, can you give details of what other patches are to come?
I'm guessing more sensor drivers and I hate discovering I'm implementing drivers
for devices that someone already has working code for!
