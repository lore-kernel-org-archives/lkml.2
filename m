Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189Ab0H3KxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 06:53:20 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53548 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663Ab0H3KxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 06:53:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=C+SVgD+zXEdU2ZAXaQKxbHzjdZLrIjchOXRyj2l8MxiU4BxGlmeYk2ygSvy7aeX/Pi
         /bRZNe01jKxI3Ul01vEcR3S2rfC0fROSK86UfvLASKxQI3puAVlYoEfQ4BGFLr3c/LAb
         pMWmuAD5FsAgnGnmKfj9ANFBlhOIPIxcNrhuU=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Two patches for my xD support [RESEND]
Date: Mon, 30 Aug 2010 13:53:07 +0300
Message-Id: <1283165589-10334-1-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These are two small patches, one to fix a mistake which should be harmless, but still
a mistake, and the other one small cosmetic refactoring.
David Woodhouse, can you queue that to 2.6.36?

Best regards,
	Maxim Levitsky 


