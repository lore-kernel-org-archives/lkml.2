Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147Ab0H3Ksz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 06:48:55 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34242 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754825Ab0H3Ksy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 06:48:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=afBLaFTdPgmiLljE5hvx4jb47OhzMfSyFbzTU5W1bY5vMXEE18vBgWL4nQO47786pH
         GH0OtrLGTwyGt3kyC357gxdi4oikbdhP5JGNOspPVHSWkp+d93TGWPFnENSY8W1w4fcJ
         yQUfh0bBU789+MerQ0R/LTWEzW3Ln+LzeM4Eg=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/3 RESEND] My work on MemoryStick system
Date: Mon, 30 Aug 2010 13:48:44 +0300
Message-Id: <1283165327-10144-1-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a resend of my patches for memorystick subsystem.
I mostly get positive feedback on this from the users.
(Only one user said that initialy card wasn't recognised,
but he can't reproduce that)

Please review this.

Best regards,
	Maxim Levitsky

