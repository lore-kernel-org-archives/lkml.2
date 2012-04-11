Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965115Ab2DKXTK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:19:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44096 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964989Ab2DKXS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:18:57 -0400
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org
Subject: irq_domain fixes for v3.4-rc2
Date: Wed, 11 Apr 2012 17:18:43 -0600
Message-Id: <1334186326-22649-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

Here are the fixes I'm proposing for the irq_domain issues seen on
powermac.  I had originally only intended to remove the
irq_virq_count, but I already had the hint and slow path removal
patches written and reviewed, and removing them reduces the number of
failure paths, and simplifies the code quite a bit.

I've pushed this out to the following branch for testing:

git://git.secretlab.ca/git/linux-2.6 irqdomain/test

It has been boot tested on ARM, but not powerpc.  This series of three
patches applies on top of the existing irqdomain/merge branch on my
git server:

git://git.secretlab.ca/git/linux-2.6 irqdomain/merge

Can you test on your powermac?

Thanks,
g.

