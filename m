Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807Ab1GGQdG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 12:33:06 -0400
Received: from mail-bw0-f52.google.com ([209.85.214.52]:47997 "EHLO
	mail-bw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306Ab1GGQdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 12:33:02 -0400
Subject: [PATCH 0/3] UML: Memory leak fixes.
From: Vitaliy Ivanov <vitalivanov@gmail.com>
To: Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>
Cc: user-mode-linux-devel@lists.sourceforge.net,
        LKML <linux-kernel@vger.kernel.org>, vitalivanov@gmail.com
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Jul 2011 19:34:40 +0300
Message-ID: <1310056480.3528.47.camel@vivanov>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard,

Here is a set of fixes for UML memory leak cleanups.

 arch/um/drivers/net_user.c  |    5 +++--
 arch/um/drivers/slip_user.c |    3 +--
 arch/um/os-Linux/main.c     |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

Thanks,
Vitaliy

