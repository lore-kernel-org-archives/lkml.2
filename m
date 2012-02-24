Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932416Ab2BXWon (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 17:44:43 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35897 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755583Ab2BXWom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 17:44:42 -0500
Message-ID: <4F4812D5.7060606@suse.cz>
Date: Fri, 24 Feb 2012 23:44:37 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120215 Thunderbird/10.0.2
MIME-Version: 1.0
To: Tony Luck <tony.luck@intel.com>
CC: Jiri Slaby <jirislaby@gmail.com>, fenghua.yu@intel.com,
        linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] IA64: hpsim, fix SAL handling in fw-emu
References: <1330081818-15517-1-git-send-email-jslaby@suse.cz> <CA+8MBbKtQZkp0RzsP366PgzdN2jvX73njFr1avSoE_CFDv=jNg@mail.gmail.com>
In-Reply-To: <CA+8MBbKtQZkp0RzsP366PgzdN2jvX73njFr1avSoE_CFDv=jNg@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2012 11:32 PM, Tony Luck wrote:
> Are these four patches the only things needed to get the kernel
> running on the simulator?  I've been building sim_defconfig as
> part of my regular "did things break" cycle. But I haven't tried to
> boot in well over five years.

Yes, it works fine for me. I'm using busybox as userspace. From SLES 11
SP2. I was using it to test tty patches applied to simserial.

My .config differs from sim_defconfig though. I didn't know there is a
defconfig for HP simulator. So I configured the kernel from scratch with
help of menuconfig.

thanks,
-- 
js
suse labs
