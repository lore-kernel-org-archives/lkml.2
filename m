Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681Ab1ANXVh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 18:21:37 -0500
Received: from mail.dfsv43.com ([91.103.216.11]:40879 "EHLO mail.dfsv43.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752661Ab1ANXVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 18:21:36 -0500
X-Greylist: delayed 8061 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Jan 2011 18:21:36 EST
Message-ID: <4D30BB18.6080804@vlnb.net>
Date: Sat, 15 Jan 2011 00:07:36 +0300
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: scst-devel <scst-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [ANNOUNCE]: SCST SCSI target mode subsystem 2.0.0.1 released
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - mail.dfsv43.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - vlnb.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SCST SCSI target mode subsystem 2.0.0.1 released and can be downloaded
from the SCST download page http://scst.sourceforge.net/downloads.html.

Everybody are strongly encouraged to upgrade.

Summary of changes between versions 2.0.0 and 2.0.0.1
-----------------------------------------------------

 - Fixed critical issue with wrong INQUIRY page 0x80 (r3197)

 - Possible crashes due to incorrect execution context estimations fixed

 - Responsiveness under heavy load improved

Thanks to all participated!

Vlad
