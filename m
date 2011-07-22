Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab1GVRnS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 13:43:18 -0400
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:34476 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754098Ab1GVRnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 13:43:08 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E29B6B1.2090107@cam.ac.uk>
Date: Fri, 22 Jul 2011 18:43:13 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110509 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Sysfs - export sysfs_create_subdir?
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I have a couple of cases in IIO where under some conditions
we end up using dummy attr_groups (no elements) to initialize
a sub directory before dynamically creating all of its attributes.

Now having dummy groups in the IIO core is fine, but it does seem
a little messy.

The obvious choice would be to put together a small wrapper function
for sysfs_create_subdir that also does sysfs_get on the result.

Anyone have any strong feelings on whether this is worthwhile or not?

It'll save me about 16 lines of code, so not exactly a big point,
but nice to get it right none the less!

If there is a way of doing this cleanly that I'm missing, then sorry
for the noise and please tell me what it is!

Jonathan
