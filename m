Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381Ab2ISNTN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 09:19:13 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47517 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515Ab2ISNTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 09:19:11 -0400
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alex Dubov <oakad@yahoo.com>, linux-kernel@vger.kernel.org
Subject: 
Date: Wed, 19 Sep 2012 16:19:01 +0300
Message-Id: <1348060743-6295-1-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Hi,

This is a revised generic driver for memstick standard cards,
that I posted a year ago.

I removed the scatter-gather list abuse from it, but otherwice
its unchanged.
I tested it quite a lot here and everything is fine.

Could you merge it?

Best regards,
        Maxim Levitsky
