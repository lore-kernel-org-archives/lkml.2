Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915Ab2BXLNs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 06:13:48 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63623 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609Ab2BXLNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 06:13:47 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of st.lambert02@gmail.com designates 10.220.107.79 as permitted sender) smtp.mail=st.lambert02@gmail.com; dkim=pass header.i=st.lambert02@gmail.com
MIME-Version: 1.0
Date: Fri, 24 Feb 2012 12:13:46 +0100
Message-ID: <CAOPDcRwXMYLTb+r1GgPWrgZ00d-r8XH8NeXRYgZR5vpOHRA0JA@mail.gmail.com>
Subject: Kernel panic - not syncing: junk in compressed archive
From: stl <st.lambert02@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,
I'm building a linux system for a new architecture,
and I want to use initramfs support to build a filesystem.

I have seen that there are several ways to do that with initramfs.
Either the kernel will build the cpio archive for me, or I can provide an
external one with the CONFIG_INITRAMFS_SOURCE option.

An other way is to provide a configuration file to this option.

I have tried all these methods but each time, the boot stops with the
following message:

Kernel panic - not syncing: junk in compressed archive

I have googled on that but have not found relevant solution.

Does anyone know what could generally be the cause of this problem?

Thanks in advance for your help.
