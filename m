Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998Ab1FTBWb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 21:22:31 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51430 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab1FTBW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 21:22:29 -0400
MIME-Version: 1.0
X-Originating-IP: [202.78.240.7]
In-Reply-To: <alpine.LRH.2.00.1106201036040.5170@tundra.namei.org>
References: <1308295341-27566-1-git-send-email-chrisf@ijw.co.nz>
	<alpine.LRH.2.00.1106201036040.5170@tundra.namei.org>
Date: Mon, 20 Jun 2011 13:22:28 +1200
Message-ID: <BANLkTikQSNic0vhnmu5PXkofFiDbTZyYpg@mail.gmail.com>
Subject: Re: [PATCH] security: inode: fixed coding style issue
From: Chris Forbes <chrisf@ijw.co.nz>
To: James Morris <jmorris@namei.org>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is not correct for multi-line comments.

Oops, sorry, I'll fix that.

As for the extra spaces in {{""}}, checkpatch.pl complains about it:

ERROR: space required after that close brace '}'
#129: FILE: inode.c:129:
+    static struct tree_descr files[] = {{""}};

-- Chris

[resend due to mailer unhelpfully using html]
