Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759430Ab2BJOyi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 09:54:38 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:41959 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754799Ab2BJOyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 09:54:37 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Tejun Heo <tj@kernel.org>
Cc: Danny Kukawka <dkukawka@suse.de>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Jens Axboe <jaxboe@fusionio.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] DAC960: fix some compiler warnings
Date: Fri, 10 Feb 2012 15:54:12 +0100
Message-Id: <1328885654-22461-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.7.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1328885677;92285a39;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two patches for DAC960. The first one is a resend from 26.01.2012.

Danny Kukawka (2):
  DAC960: fix DAC960_V2_IOCTL_Opcode_T -Wenum-compare warning
  DAC960: fix -Wuninitialized warning

 drivers/block/DAC960.c                     |   18 ++-
 1 files changed, 10 insertions(+), 8 deletions(-)

-- 
1.7.7.3

