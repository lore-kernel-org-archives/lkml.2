Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538Ab1BGSJm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 13:09:42 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59888 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754316Ab1BGSJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 13:09:41 -0500
From: Michal Simek <monstr@monstr.eu>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Subject: microblaze: Convert irq chip to new functions
Date: Mon,  7 Feb 2011 19:09:35 +0100
Message-Id: <1297102176-20768-1-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

I have tested them and there are several problems which I've fixed.
I have added that changes to your patch 2/3. I am sending them as v2.

For all others patches:
Tested-by: Michal Simek <monstr@monstr.eu>

They can go through your tree because you have all patches around irq.

Thanks,
Michal


