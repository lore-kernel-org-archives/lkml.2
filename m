Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744Ab2BVQFM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 11:05:12 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:37342 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753655Ab2BVQFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 11:05:05 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Tejun Heo <tj@kernel.org>
Cc: Danny Kukawka <dkukawka@suse.de>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: [RESEND][PATCH 0/2] drivers/block/DAC960: fix some compiler warnings
Date: Wed, 22 Feb 2012 17:04:39 +0100
Message-Id: <1329926681-6057-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.8.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1329926705;ed5417eb;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two patches for DAC960. Please add to 3.3.

Please note: I didn't touch the code style/indentation of the file.

Danny Kukawka (2):
  drivers/block/DAC960: fix DAC960_V2_IOCTL_Opcode_T -Wenum-compare warning
  drivers/block/DAC960: fix -Wuninitialized warning

 drivers/block/DAC960.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

-- 
1.7.8.3

