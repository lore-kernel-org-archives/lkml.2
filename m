Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505Ab2C0Gjl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 02:39:41 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:60003 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750760Ab2C0Gjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 02:39:39 -0400
MIME-Version: 1.0
Date: Tue, 27 Mar 2012 14:39:37 +0800
Message-ID: <CAFNq8R5FqEZG1rx54LSv-iAcc9keG-dNKe5fAiEWMBe2sS-nSg@mail.gmail.com>
Subject: To built-in Driver, When the corresponding node under /dev created?
From: Li Haifeng <omycle@gmail.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As you know, the node under /dev are managed by udevd daemon.

But to the built-in driver module, when the module is probed in kernel
space, udevd daemon doesn't running. So, to ttyS node, when the
built-in driver module was probed, when was the /dev/ttyS  created?

Thanks.
