Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369Ab1FNFMk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 01:12:40 -0400
Received: from cantor.suse.de ([195.135.220.2]:58619 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844Ab1FNFMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 01:12:38 -0400
Message-ID: <4DF6EE1C.9090803@suse.cz>
Date: Tue, 14 Jun 2011 07:14:04 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [3.0-rc3] scripts/depmod.sh: Permission denied
References: <201106140041.p5E0fhAh029531@www262.sakura.ne.jp>
In-Reply-To: <201106140041.p5E0fhAh029531@www262.sakura.ne.jp>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 14.6.2011 02:41, Tetsuo Handa napsal(a):
> linux-3.0-rc3.tar.bz2 generates
> -rwxrwxr-x  1 root root 1231 Jun 14 07:29 linux-3.0-rc3/scripts/depmod.sh
> but linux-2.6.39.tar.bz2 + patch-3.0-rc3.bz2 generates
> -rw-r--r--  1 root root 1231 Jun 14 09:34 scripts/depmod.sh
> which results in

Ah, I forgot about patch(1) users.


> make: execvp: /usr/src/linux-3.0-rc3/scripts/depmod.sh: Permission denied
> make: *** [_modinst_post] Error 127
> 
> Would you add "chmod +x scripts/depmod.sh" before invoking depmod.sh ?

I'll change the call to $(CONFIG_SHELL) $(scrtree)/scripts/depmod.sh
instead.

Michal
