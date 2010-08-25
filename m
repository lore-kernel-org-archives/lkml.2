Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab0HYMzL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 08:55:11 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49501 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631Ab0HYMzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 08:55:09 -0400
From: Michal Simek <monstr@monstr.eu>
To: linux-kernel@vger.kernel.org
Cc: linux-serial@vger.kernel.org, gregkh@suse.de
Subject: uartlite - fix poll support
Date: Wed, 25 Aug 2010 14:55:03 +0200
Message-Id: <1282740904-1244-1-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I forget to CC Peter Korsgaard (sorry for that again) and he found one obscure thing
in my first patch. This second patch removes it. It will be the best
to add those two patches together but I am not sure if is possible. It depends
on Greg maintaining process. (If is possible I would like to ask for it).

Peter: I added your Signed-off-by line I hope that you are OK with it.

Greg: If there are no problems with it, please add to your tty tree or add together
with the first patch.

Thanks,
Michal



