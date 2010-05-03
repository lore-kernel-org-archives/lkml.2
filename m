Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892Ab0ECJJj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 05:09:39 -0400
Received: from stag.seas.upenn.edu ([158.130.70.79]:36727 "EHLO
	stag.seas.upenn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829Ab0ECJJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 05:09:38 -0400
From: Rafi Rubin <rafi@seas.upenn.edu>
To: linux-input@vger.kernel.org, jkosina@suse.cz, chatty@enac.fr
Cc: dmitry.torokhov@gmail.com, micki@n-trig.com, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] hid-ntrig.c tipswitch and cleanup
Date: Mon,  3 May 2010 05:08:28 -0400
Message-Id: <1272877710-25431-1-git-send-email-rafi@seas.upenn.edu>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[PATCH 1/2] TipSwitch for single touch mode touch.
This patch is a resubmit of a recent patch which might have been lost due
to the discussion of a distasteful comment (which has been sanitized).  Note
this does not increase the use of TAP events in the driver, though it also does
not remove them.


[PATCH 2/2] Remove unused macro, TripleTap and QuadTap
This patch marks the start of the removal of TAP events from hid-ntrig.  I will
remove DoubleTap when the wacom X driver is capable of interpreting MT events,
which is currently a work in progress.

