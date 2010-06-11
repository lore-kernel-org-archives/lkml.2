Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760465Ab0FKUlO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 16:41:14 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51209 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756917Ab0FKUlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 16:41:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=jzdeSg7Is2J0jHrX/0L5EhDOX0sUfJluMAyzM99f2DG8itFbqIOnBA3ILUWPmvMUQX
         XVO4GHdPdQRhpBb+iT8jLnv5L+xhMmSOWiyLdQI3HpV1HCDtnjY7VZ27p4lWVim1OHZ6
         Deei9QLcdyqbby64moDA19LSoVVrJZ7kVCmyU=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-audit@redhat.com, zippel@linux-m68k.org,
       linux-fsdevel@vger.kernel.org, rusty@rustcorp.com.au
Subject: [PATCH 0/6] Fix gcc warnings of unused variables etc.. 
Date: Fri, 11 Jun 2010 13:41:03 -0700
Message-Id: <1276288869-16815-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




This set of patches, basically shuts-up
the warning messages by gcc-4.6.0.
As of now I just went through some
of the trivial ones that might be dead
code reported by gcc(but could be wrong).

Please have a look, if somebody has a better
way of dealing with this, let me know, and 
I can test some patches..

Justin P. Mattock

