Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684Ab0IYFRQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 01:17:16 -0400
Received: from smtp.nexicom.net ([216.168.96.13]:59152 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752242Ab0IYFRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 01:17:14 -0400
X-Greylist: delayed 380 seconds by postgrey-1.27 at vger.kernel.org; Sat, 25 Sep 2010 01:17:14 EDT
Message-ID: <4C9D845A.4060105@lockie.ca>
Date: Sat, 25 Sep 2010 01:10:50 -0400
From: James <bjlockie@lockie.ca>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100908 Lightning/1.0b3pre Thunderbird/3.1.3
MIME-Version: 1.0
To: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: no modules :-)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 I don't like modules. :-)

What is pulling this in:

CONFIG_SCSI_WAIT_SCAN=m

I edited .config but make must have turned it back on.
