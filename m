Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758812Ab0JFJFl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 05:05:41 -0400
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:51984 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754363Ab0JFJFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 05:05:39 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] DMAENGINE: DMA40 burst size conquest
Date: Wed, 6 Oct 2010 11:05:26 +0200
Message-ID: <1286355929-31226-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

this patch set gives the device runtime control functions complete
control over burst size, and remove the local hooks to handle this
in the platform code.

Since [2/3] touches platform code that was touch by stuff queued
up in Russells ARM tree, I took it out of his patch tracker and
included it in this patch set instead so as to avoid conflicts, hope
it's OK.

This can go on top of the bug fixes send earlier, but will probably
also apply on their own.

Yours,
Linus Walleij

