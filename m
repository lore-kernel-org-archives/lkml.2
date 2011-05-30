Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031Ab1E3IqG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 04:46:06 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52601 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab1E3IqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 04:46:05 -0400
Date: Mon, 30 May 2011 10:45:59 +0200
From: Aiko Barz <aiko@chroot.de>
To: linux-kernel@vger.kernel.org
Subject: sendfile/splice - Non-blocking input?
Message-ID: <20110530084559.GA19320@wind>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

is sendfile/splice completely non-blocking on the input side?

I am writing a small webserver for educational reasons. I use epoll to
deal with the network part. From what I have read, I have to avoid
blocking code under all circumstances. And the linux implementation
of sendfile seems to block until the file enters the pagecache.

Most of the docs are not completely up to date. I figured out, that
sendfile is now a frontend for splice. So, does it still block?

Or differently asked: May I call sendfile directly from the few epoll
threads or do I have to execute sendfile/splice within independent
worker threads?

Kind regards,
	Aiko Barz
-- 
:wq ✉
