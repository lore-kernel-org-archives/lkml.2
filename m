Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690Ab1BITuJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 14:50:09 -0500
Received: from lo.gmane.org ([80.91.229.12]:55842 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822Ab1BITuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 14:50:08 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bernd Eggink <monoped@sudrala.de>
Subject: "HDIO_GET_IDENTITY failed" messages in 2.6.38-rc4
Date: Wed, 09 Feb 2011 18:16:07 +0100
Message-ID: <iiui4n$pcb$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: d053035.adsl.hansenet.de
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a system with a SCSI CD burner (Plextor). Worked fine under 
2.6.37, but 2.6.38-rc4, when booting, floods the display with messages 
"HDIO_GET_IDENTITY failed for /dev/sr0".
Which kernel option could be wrong?

Thanks for any help,
Bernd

