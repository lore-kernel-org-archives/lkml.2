Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185Ab1BCPIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 10:08:24 -0500
Received: from lo.gmane.org ([80.91.229.12]:55364 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752404Ab1BCPIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 10:08:22 -0500
X-Injected-Via-Gmane: http://gmane.org/
Mail-Followup-To: linux-kernel@vger.kernel.org
To: linux-kernel@vger.kernel.org
From: Nikolaus Rath <Nikolaus@rath.org>
Subject: How to check if DMA uses bounce buffer
Date: Thu, 03 Feb 2011 10:01:15 -0500
Message-ID: <87pqr9cgck.fsf@inspiron.ap.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: ebox.rath.org
Mail-Copies-To: never
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
Cancel-Lock: sha1:n5JcToBASTZ8qIjZ5dN8WNxJgoY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Is there a way to check if a dma mapping set up with dma_map_single will
write directly into the provided buffer, or if the transfer will go
through a bounce buffer?


Thanks,

   -Nikolaus

-- 
 »Time flies like an arrow, fruit flies like a Banana.«

  PGP fingerprint: 5B93 61F8 4EA2 E279 ABF6  02CF A9AD B7F8 AE4E 425C

