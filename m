Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932927Ab2JaMyH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 08:54:07 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:36791 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab2JaMyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 08:54:03 -0400
Message-ID: <50911F67.3040303@suse.cz>
Date: Wed, 31 Oct 2012 13:53:59 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: Jiri Slaby <jirislaby@gmail.com>, gregkh@linuxfoundation.org,
        alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 21/21] TTY: move tty buffers to tty_port
References: <1350592007-9216-1-git-send-email-jslaby@suse.cz> <1350592007-9216-22-git-send-email-jslaby@suse.cz> <50897E98.5080502@gmail.com>
In-Reply-To: <50897E98.5080502@gmail.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2012 08:02 PM, Sasha Levin wrote:
> Fuzzing with trinity inside a KVM tools (lkvm) guest with -next kernel
> uncovered the following warning:

I cannot reproduce that :(. Do you still see it?

> [ 1339.448706] ------------[ cut here ]------------
> [ 1339.451224] WARNING: at drivers/tty/tty_buffer.c:476 flush_to_ldisc+0x60/0x200()
> [ 1339.454272] tty is NULLPid: 7147, comm: kworker/4:0 Tainted: G        W    3.7.0-rc2-next-20121025-sasha-00001-g673f98e-dirty #75
> [ 1339.458693] Call Trace:
> [ 1339.459410]  [<ffffffff81bb1ea0>] ? flush_to_ldisc+0x60/0x200
> [ 1339.461289]  [<ffffffff81109b86>] warn_slowpath_common+0x86/0xb0
> [ 1339.462992]  [<ffffffff81109c11>] warn_slowpath_fmt+0x41/0x50
> [ 1339.464772]  [<ffffffff81bb1ea0>] flush_to_ldisc+0x60/0x200

thanks,
-- 
js
suse labs
