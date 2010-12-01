Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985Ab0LAFf1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 00:35:27 -0500
Received: from n16.c03.server-system.net ([72.47.224.16]:60497 "EHLO
	n16.c03.server-system.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303Ab0LAFfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 00:35:25 -0500
X-Greylist: delayed 1833 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Dec 2010 00:35:25 EST
Message-ID: <4CF5DE96.6040706@azabani.com>
Date: Wed, 01 Dec 2010 13:35:18 +0800
From: Delan Azabani <delan@azabani.com>
Reply-To: delan@azabani.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: drivers/serial/8250.c:2411:1: internal compiler error: Segmentation
 fault
References: <4CF5D76C.6080606@azabani.com>
In-Reply-To: <4CF5D76C.6080606@azabani.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
X-Authenticated-User: 85653 delan@azabani.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/10 13:04, Delan Azabani wrote:
> Compiling the latest from linux/kernel/git/torvalds/linux-2.6 fails on
> drivers/serial/8250.c regardless of config (default config or Ubuntu
> config):
>
> ...
>
> drivers/serial/8250.c: In function ‘serial8250_do_set_termios’:
> drivers/serial/8250.c:2411:1: internal compiler error: Segmentation fault
> Please submit a full bug report,
> with preprocessed source if appropriate.
> See <file:///usr/share/doc/gcc-4.5/README.Bugs> for instructions.
> make[3]: *** [drivers/serial/8250.o] Error 1
> make[3]: *** Waiting for unfinished jobs....
>
> ...
>
> make[2]: *** [drivers/serial] Error 2
> make[2]: *** Waiting for unfinished jobs....
>
> ...
>
> make[1]: *** [drivers] Error 2
> make[1]: Leaving directory `/home/delan/Build/linux-2.6'
> make: *** [debian/stamp/build/kernel] Error 2
> delan@delan1:~/Build/linux-2.6$
>
> I don't know if this is a kernel source issue or, as the output states,
> a gcc issue with 4:4.5.1-1ubuntu3. I'll try compiling the mainline
> kernel, rather than git, to see if this is still an issue.

Looks like it's a gcc issue. I'm going to test a gcc snapshot.
