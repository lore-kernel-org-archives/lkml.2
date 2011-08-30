Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982Ab1H3Lxf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 07:53:35 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37493 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab1H3Lxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 07:53:30 -0400
From: marcus.folkesson@gmail.com
To: Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: high speed (921.6 kbit/s).
Date: Tue, 30 Aug 2011 13:53:09 +0200
Message-Id: <1314705190-5819-1-git-send-email-marcus.folkesson@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <y>
References: <y>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After this work around was implemented the system seems to behave good.

In fact, I don't really see why the system should hang since there is a 
max counter, so the loop cannot run forever.

The patch is tested on kernel version 2.6.32, but the driver is allmost
the same.

Please take a look.
Feedback is very much appreciated

>From Marcus Folkesson <marcus.folkesson@combitech.se> # This line is ignored.
From: Marcus Folkesson <marcus.folkesson@combitech.se>
Subject: [PATCH] serial: pxa: a brief description
In-Reply-To: marcus.folkesson@gmail.com

