Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150Ab0DGSku (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 14:40:50 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:52883 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757004Ab0DGSks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 14:40:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=mQsV/h30Rj0hVD2854Sk5jU+qQZ66GXYNymK+dZ0/jDSDKHEIrSdVCMP7Lj7vYK6o6
         i2E3NAex4AAqsQ8/6IvtowC5OgX0XOYUe2uZGnDdAOfScKs2bu2vBJa439QKXGORK54+
         3MabFdZzeAADyKIW9EkUHqLfC9Szrj475S13Y=
From: John Kacur <jkacur@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>,
       rt-users <linux-rt-users@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
       Clark Williams <williams@redhat.com>, John Kacur <jkacur@redhat.com>
Subject: [rt: PATCH - resend] Fix-up boot-up warnings surrounding CONFIG_STACK_TRACER
Date: Wed,  7 Apr 2010 20:40:39 +0200
Message-Id: <1270665640-8520-1-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas

I respun this against 2.6.33.2-rt13 and combined the two original patches
into one as suggested by Steven Rostedt, and added his Acked-by.

Please consider this patch for the next -rt release.

Thanks

John Kacur (1):
  rt: This fixes the boot-up messages related to CONFIG_STACK_TRACER

 init/main.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

