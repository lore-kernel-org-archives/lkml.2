Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757774Ab2DJSUD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 14:20:03 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:40376 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755521Ab2DJSUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 14:20:01 -0400
Message-ID: <4F8479CD.5030907@suse.cz>
Date: Tue, 10 Apr 2012 20:19:57 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120404 Thunderbird/13.0a2
MIME-Version: 1.0
To: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: /proc/interrupts has non-printable chars in kernel 3.3.1
References: <201204101934.34046.toralf.foerster@gmx.de>
In-Reply-To: <201204101934.34046.toralf.foerster@gmx.de>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2012 07:34 PM, Toralf Förster wrote:
> The interrrupt 47 shows (with powertop) a curious "Description" :
> 
> [@^EM-W] <interrupt>
> 
> under a stable Gentoo Linux at a Thinkpad T400  - the BIOS is the latest 
> available. FWIW I attached the output of the command  $>cat /proc/interrupts
...
>  47:     289270     468524   PCI-MSI-edge      @��

It would be great if you could dig out of dmesg, who is bound to the
interrupt.

regards,
-- 
js
suse labs

