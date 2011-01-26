Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab1AZTpZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 14:45:25 -0500
Received: from lucidpixels.com ([75.144.35.66]:48513 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728Ab1AZTpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 14:45:24 -0500
Date: Wed, 26 Jan 2011 14:45:23 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
cc: linux-scsi@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
Subject: 3w-sas 0000:02:00.0: vpd r/w failed.
Message-ID: <alpine.DEB.2.00.1101261444130.32464@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Kernel 2.6.37, I have been running a 9750-24i4e for a while now, no 
problems, but I saw this today, what does it mean, what would cause it?

Would not using barriers cause this problem (e.g., nobarrier mount 
option?)

[475380.769837] 3w-sas 0000:02:00.0: vpd r/w failed.  This is likely a firmware bug on this device.  Contact the card vendor for a firmware update.

Justin.

