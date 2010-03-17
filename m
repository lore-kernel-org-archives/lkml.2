Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609Ab0CQQ0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 12:26:19 -0400
Received: from mail.digidescorp.com ([66.244.163.200]:53880 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233Ab0CQQ0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 12:26:13 -0400
X-Spam-Processed: digidescorp.com, Wed, 17 Mar 2010 11:26:11 -0500
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=16925da2b5=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
From: "Steven J. Magnani" <steve@digidescorp.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, microblaze-uclinux@itee.uq.edu.au,
       monstr@monstr.eu, Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 0/4] dmaengine: Add driver for Xilinx MPMC
Date: Wed, 17 Mar 2010 11:25:58 -0500
Message-Id: <1268843158-15223-1-git-send-email-steve@digidescorp.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a DMA engine driver for SDMA channels on a Xilinx Multi-Port
Memory Controller (MPMC). 

Caveats:
* The OF bus driver (part 4) is based on the fsldma driver and how I
  thought the device and channels might be represented in a device tree blob.
  As I don't use OF in my kernel, all I am able to do is verify that the code
  compiles. Suggestions for improvement are especially welcome here.

* Similarly, I took a stab at DCR support based on the ll_temac driver
  and some discussions about supporting both DCR and simple pointer access
  to device registers. I'm working on Microblaze so cannot test the DCR code.

Regards,
------------------------------------------------------------------------
 Steven J. Magnani               "I claim this network for MARS!
 www.digidescorp.com              Earthling, return my space modulator!"

 #include <standard.disclaimer>


