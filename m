Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156Ab2ASHbJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 02:31:09 -0500
Received: from rrzmta2.uni-regensburg.de ([194.94.155.52]:45942 "EHLO
	rrzmta2.uni-regensburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535Ab2ASHbH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 02:31:07 -0500
Message-Id: <4F17D4C2020000A100008B19@gwsmtp1.uni-regensburg.de>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Thu, 19 Jan 2012 08:30:58 +0100
From: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
To: <linux-kernel@vger.kernel.org>
Subject: Change request: "scsi: killing requests for dead queue"
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I have a change request: I saw three message that I couldn't bring into context with any other event (SLES11 SP1 (2.6.32.49-0.3-default)):

Jan 18 15:33:04 h03 kernel: [2866825.805434] scsi: killing requests for dead queue
Jan 18 15:33:04 h03 kernel: [2866825.812129] scsi: killing requests for dead queue
Jan 18 15:33:04 h03 kernel: [2866825.815553] scsi: killing requests for dead queue

Unfortunately the kernel message doesn't give some kind of queue identifier, so that's hard to correlate with any other events.

Can this message be improved to include some variable output?

Regards,
Ulrich Windl


