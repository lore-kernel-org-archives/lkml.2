Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903Ab1AUHuE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 02:50:04 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55974 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207Ab1AUHuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 02:50:01 -0500
From: Michal Simek <monstr@monstr.eu>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Subject: mm.h: Fix noMMU breakage
Date: Fri, 21 Jan 2011 08:49:55 +0100
Message-Id: <1295596196-8233-1-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

all noMMU systems are broken that's why I would like to add
this patch (or any similar/better) to mainline ASAP. 
For more information please look at patch description.

Can you give me some ACKs?

Who is responsible for this mm patch? Andrew?

Thanks,
Michal


