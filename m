Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870Ab2CUXXk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 19:23:40 -0400
Received: from mail.tomasu.net ([64.85.170.232]:59805 "EHLO mail.tomasu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755914Ab2CUXXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 19:23:37 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Mar 2012 19:23:36 EDT
From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Reply-To: thomas@fjellstrom.ca
To: lkml <linux-kernel@vger.kernel.org>
Subject: stuck in megaraid_sas.c megasas_adp_reset_gen2
Date: Wed, 21 Mar 2012 17:16:45 -0600
User-Agent: KMail/1.13.7 (Linux/3.2.0-1-amd64; KDE/4.7.4; x86_64; ; )
Cc: linux-scsi@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201203211716.45418.thomas@fjellstrom.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I recently got an IBM M1015 (MegaRaid 9240-8i) card, and after getting a new 
motherboard, the system now boots, but the megaraid_sas driver seems to be 
getting stuck when trying to initialize the card.

Looking through the source, it seems to be stuck in the megasas_adp_reset_gen2 
function, in the while loop at the end. Now, according to the code it can't 
actually get stuck there permanently, but it does take quite a while for the 
loop to finish, and the udev timeout messages to stop.

I've looked around quite a bit, but haven't found any solutions thus far. If 
anyone could point me in the right direction I'd appreciate it.

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
