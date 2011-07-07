Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634Ab1GGRz4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 13:55:56 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43289 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880Ab1GGRz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 13:55:56 -0400
Date: Thu, 7 Jul 2011 13:55:52 -0400
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Minor cleanups
Message-ID: <20110707175552.GA2671@tj-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I changed a Makefile to stop using a deprecated build flag
and fixed a spelling error.

Tracey Dent (2):
  Altera-stapl: Clean up makefile (-y instead of -objs)
  Ath6kl: TODO: Fix spelling :)

 drivers/staging/altera-stapl/Makefile |    2 +-
 drivers/staging/ath6kl/TODO           |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
1.7.6.131.g99019

