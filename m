Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754Ab1HWSyW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 14:54:22 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37205 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755687Ab1HWSyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 14:54:13 -0400
Message-ID: <4E53F750.2050408@suse.cz>
Date: Tue, 23 Aug 2011 20:54:08 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: gregkh@suse.de, alan@linux.intel.com,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: patch "TTY: remove tty_locked" added to tty tree
References: <13141210141189@kroah.org> <4E53F282.10908@suse.cz> <2337681.paSeVyBarJ@wuerfel>
In-Reply-To: <2337681.paSeVyBarJ@wuerfel>
X-Enigmail-Version: 1.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2011 08:46 PM, Arnd Bergmann wrote:
> According to http://kernelnewbies.org/BigKernelLock, I concluded back then
> that tty_wait_until_sent would always be called without BTM held. Has that
> changed recently, or did I miss a caller that holds the BTM?

Every tty_operations->close and ->hangup :).

-- 
js
suse labs
