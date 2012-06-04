Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760405Ab2FDPUL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 11:20:11 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:40539 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab2FDPUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 11:20:09 -0400
Message-ID: <4FCCD224.1020307@suse.cz>
Date: Mon, 04 Jun 2012 17:20:04 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120530 Thunderbird/14.0a2
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: Jiri Slaby <jirislaby@gmail.com>, gregkh@linuxfoundation.org,
        alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Jeff Dike <jdike@addtoit.com>,
        user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH 13/24] TTY: um/line, use tty from tty_port
References: <1338809738-18967-1-git-send-email-jslaby@suse.cz> <1338809738-18967-14-git-send-email-jslaby@suse.cz> <4FCCA3A6.8080608@nod.at>
In-Reply-To: <4FCCA3A6.8080608@nod.at>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2012 02:01 PM, Richard Weinberger wrote:
> I have two questions: 1. Are these patches also usable on 3.4 and
> 3.3 or do they depend on 3.5's TTY changes?

Hi, I don't think they depend on any changes.

> 2. Why didn't you use tty_port_open()/close()/etc. as Alan
> suggested my in [1]?

This was not intended to fix anything particular. If it does, it is a
pure coincidence... These patches are a minimalistic subset to ensure
every driver has its own tty_port for each tty. We will need this
pairing later.

So the switch of the driver to the new tty port API, as suggested by
Alan, is still needed. I might do that later if I learn how to make
UML work. (The conversion is by definition invasive and needs runtime
testing.)

> [1]
> http://lkml.indiana.edu/hypermail/linux/kernel/1201.3/01705.html

thanks,
-- 
js
suse labs

