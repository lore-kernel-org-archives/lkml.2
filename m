Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590Ab1GAIr4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 04:47:56 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:11963 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755447Ab1GAIrz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 04:47:55 -0400
Date: Fri, 1 Jul 2011 10:47:28 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Nathan Royer <nroyer@invensense.com>
Cc: Alan Cox <alan@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Jonathan Cameron <jic23@cam.ac.uk>, Jiri Kosina <jkosina@suse.cz>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 11/11] misc: Add slave driver for bma085 pressure sensor
Message-ID: <20110701104728.3ad9a670@endymion.delvare>
In-Reply-To: <20110701085604.0aabd6f1@bob.linux.org.uk>
References: <1309486707-1658-1-git-send-email-nroyer@invensense.com>
	<1309486707-1658-11-git-send-email-nroyer@invensense.com>
	<20110701085604.0aabd6f1@bob.linux.org.uk>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jul 2011 08:56:04 +0100, Alan Cox wrote:
> The slave devices all appear to be generic i2c interface hardware. I
> don't see why they are separate special slave devices to your driver,
> they should simply be i²c drivers so they can be used when those
> devices are found without the mpu3050.

Seconded. As a matter of fact, we already have a driver for the AK8975
magnetometer:
drivers/staging/iio/magnetometer/ak8975.c

-- 
Jean Delvare
