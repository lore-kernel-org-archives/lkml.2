Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab0JKNhm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 09:37:42 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:50723 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754315Ab0JKNhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 09:37:41 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4CB3147A.1050103@cam.ac.uk>
Date: Mon, 11 Oct 2010 14:43:22 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100928 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Samu Onkalo <samu.p.onkalo@nokia.com>
CC: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCHv3 1/5] misc: Driver for bh1770glc / sfh7770 ALS and proximity
 sensor
References: <1286795209-12487-1-git-send-email-samu.p.onkalo@nokia.com> <1286795209-12487-2-git-send-email-samu.p.onkalo@nokia.com>
In-Reply-To: <1286795209-12487-2-git-send-email-samu.p.onkalo@nokia.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/10 12:06, Samu Onkalo wrote:
> This is a driver for ROHM BH1770GLC and OSRAM SFH7770 combined
> ALS and proximity sensor.
> 
> Interface is sysfs based. The driver uses interrupts to provide new data.
> The driver supports pm_runtime and regulator frameworks.
> 
> See Documentation/misc-devices/bh1770glc.txt for details
> 
> Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
> ---
>  drivers/misc/bh1770glc.c      | 1413 +++++++++++++++++++++++++++++++++++++++++
>  include/linux/i2c/bh1770glc.h |   53 ++
>  2 files changed, 1466 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/misc/bh1770glc.c
...
