Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947Ab1KVNkA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 08:40:00 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54730 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab1KVNj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 08:39:58 -0500
From: Marcus Folkesson <marcus.folkesson@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] mfd: tps65910: Handle clear-mask correctly desc 
Date: Tue, 22 Nov 2011 14:39:50 +0100
Message-Id: <1321969191-8604-1-git-send-email-marcus.folkesson@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <Marcus Folkesson <marcus.folkesson@gmail.com>
References: <Marcus Folkesson <marcus.folkesson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clear the bitmask as the function says.

I was just wondering why my regulator did not turn off... :-)

