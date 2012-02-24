Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932362Ab2BXWcS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 17:32:18 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64543 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756766Ab2BXWcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 17:32:17 -0500
MIME-Version: 1.0
In-Reply-To: <1330081818-15517-1-git-send-email-jslaby@suse.cz>
References: <1330081818-15517-1-git-send-email-jslaby@suse.cz>
Date: Fri, 24 Feb 2012 14:32:16 -0800
X-Google-Sender-Auth: h32Qlk9fHSScK98SKbv34IkSX_0
Message-ID: <CA+8MBbKtQZkp0RzsP366PgzdN2jvX73njFr1avSoE_CFDv=jNg@mail.gmail.com>
Subject: Re: [PATCH 1/4] IA64: hpsim, fix SAL handling in fw-emu
From: Tony Luck <tony.luck@intel.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: fenghua.yu@intel.com, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Are these four patches the only things needed to get the kernel
running on the simulator?  I've been building sim_defconfig as
part of my regular "did things break" cycle. But I haven't tried to
boot in well over five years.

-Tony
