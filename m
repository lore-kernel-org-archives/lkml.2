Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751259Ab2CWEAK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 00:00:10 -0400
Received: from hermod.sentelic.com ([203.69.18.19]:8360 "EHLO
	hermod.sentelic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab2CWEAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 00:00:07 -0400
From: Tai-hwa Liang <avatar@sentelic.com>
To: Oskari Saarenmaa <os@ohmu.fi>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/5] Input: sentelic - multiple finger output support
Date: Fri, 23 Mar 2012 11:52:16 +0800
Message-Id: <1332474741-19426-1-git-send-email-avatar@sentelic.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch set (against for-linus) is intended to add support for newer
Sentelic FSP(hardware revision Cx/Dx).  The relative coordinates output
mode is retained for supporting older hardware(prior to Cx release).

Patch set v2 are mostly identical to the previous submission except:
- fsp_packet_debug() parameter fixing up in patch #5
- acknowledge the work done by Oskari Saarenmaa <os@ohmu.fi>

Tai-hwa Liang (5):
  Input: sentelic - code refactorying for upcoming new hardware support
  Input: sentelic - enabling absolute coordinates output for newer
    hardware
  Input: sentelic - enabling hardware supported gesture ID output
  Input: sentelic - minor code cleaning up
  Input: sentelic - improving packet debugging information

 drivers/input/mouse/sentelic.c |  297 ++++++++++++++++++++++++++++++++--------
 drivers/input/mouse/sentelic.h |  108 ++++++++++++++-
 2 files changed, 347 insertions(+), 58 deletions(-)

-- 
1.7.9

