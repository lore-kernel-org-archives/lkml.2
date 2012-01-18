Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757703Ab2ARU4x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 15:56:53 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36608 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756617Ab2ARU4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 15:56:52 -0500
MIME-Version: 1.0
Date: Wed, 18 Jan 2012 12:56:52 -0800
Message-ID: <CAGXu5jKOYOR0m+iza3SPM8qeirJjsFS3vvp300x-rvd4qnAc9w@mail.gmail.com>
Subject: change in protections of /proc/$pid/mem
From: Kees Cook <keescook@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Roland McGrath <roland@hack.frob.com>
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In e268337dfe26dfc7efd422a804dbb27977a3cccc, the logic for interacting
with /dev/$pid/mem was changed. It seems that the requirement that the
reader/writer must be actively attached to the inferior has been
dropped. Is this wise, to allow multiple read/writers of /dev/$pid/mem
even if they are not ptracing? The protection has been there for a
while, and I don't see the reason for removing it. I can't find a
discussion about this change -- where did that happen?

-Kees

-- 
Kees Cook
ChromeOS Security
