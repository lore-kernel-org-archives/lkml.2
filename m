Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757885Ab0FIQBh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 12:01:37 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55631 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757710Ab0FIQBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 12:01:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=hsH4eJJ/KugdfIki2lFD1DlOYVLT/2csZ7SZ//GKhB0lg7xVZECNozgxmHqN5oYO0V
         6C/u7qNQC89mS7wvlgFuL+EtJi10ZdkvoGNMrcJ01b0EKWIE+e0qS+rMzGtTLZI2cKop
         YowKtNz+racnOcXLr6weFCVa2OMb0C2ngtLIg=
From: John Kacur <jkacur@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Darren Hart <dvhltc@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH 0/2] trace-cmd, kernel analysis tool Makefile changes
Date: Wed,  9 Jun 2010 18:01:26 +0200
Message-Id: <1276099288-3029-1-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve
These patches were generated against the 1.0.1 version of trace-cmd.
The second one should apply to the devel version as well.

John Kacur (2):
  trace-cmd: Makefile - EXTRAVERSION should be set without a leading
    period
  trace-cmd: Makefile - use a substitution reference

 Documentation/Makefile |    6 +++---
 Makefile               |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

