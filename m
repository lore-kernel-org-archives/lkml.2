Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab0JKNlH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 09:41:07 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:44684 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665Ab0JKNlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 09:41:05 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4CB31545.70009@cam.ac.uk>
Date: Mon, 11 Oct 2010 14:46:45 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100928 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Samu Onkalo <samu.p.onkalo@nokia.com>
CC: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCHv3 3/5] misc: Driver for APDS990X ALS and proximity sensors
References: <1286795209-12487-1-git-send-email-samu.p.onkalo@nokia.com> <1286795209-12487-4-git-send-email-samu.p.onkalo@nokia.com>
In-Reply-To: <1286795209-12487-4-git-send-email-samu.p.onkalo@nokia.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/10 12:06, Samu Onkalo wrote:
> This is a driver for Avago APDS990X combined ALS and proximity sensor.
> 
> Interface is sysfs based. The driver uses interrupts to provide new data.
> The driver supports pm_runtime and regulator frameworks.
> 
> See Documentation/misc-devices/apds990x.txt for details
> 
> Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
> ---
>  drivers/misc/apds990x.c      | 1295 ++++++++++++++++++++++++++++++++++++++++++
>  include/linux/i2c/apds990x.h |   79 +++
>  2 files changed, 1374 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/misc/apds990x.c
>  create mode 100644 include/linux/i2c/apds990x.h
