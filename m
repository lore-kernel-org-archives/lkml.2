Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398Ab1CUUB3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 16:01:29 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:56688 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355Ab1CUUB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 16:01:28 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4D87AEE0.8000807@cam.ac.uk>
Date: Mon, 21 Mar 2011 20:02:40 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110122 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
        David Brownell <david-b@pacbell.net>
Subject: Standard handling of boolean attributes in sysfs.
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

Just wondering what the feeling would be about having
a utility function similar to sysfs_streq to provide a
consistent option for all those sysfs attributes out there
where

1, on, true -> 1
0, off, false -> 0

Or does such a beast already exist and I'm just being unobservant?

Jonathan
