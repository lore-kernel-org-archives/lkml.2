Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756475Ab0DFUmW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 16:42:22 -0400
Received: from imr1.ericy.com ([198.24.6.9]:45580 "EHLO imr1.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752927Ab0DFUmP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 16:42:15 -0400
Subject: Re: [PATCH][RESEND] x86: Do not write to VGA memory space if
 CONFIG_VGA_CONSOLE is undefined
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: hpa@zytor.com, linux-kernel@vger.kernel.org
CC: penberg@cs.helsinki.fi, mingo@redhat.com, x86@kernel.org
In-Reply-To: <4BBB96D7.1040302@zytor.com>
References: <1270046479-4486-1-git-send-email-guenter.roeck@ericsson.com>
	 <84144f021003310832i3420e4c1g7396b4d1f311f393@mail.gmail.com>
	 <1270491029.1477.453.camel@groeck-laptop>  <4BBA3021.9090504@zytor.com>
	 <1270497725.1477.488.camel@groeck-laptop>  <4BBA473D.9040004@zytor.com>
	 <1270501481.1477.521.camel@groeck-laptop>  <4BBA51F3.7070808@zytor.com>
	 <1270505579.1477.584.camel@groeck-laptop>  <4BBB96D7.1040302@zytor.com>
Content-Type: text/plain
Organization: Ericsson
Date: Tue, 6 Apr 2010 13:37:09 -0700
Message-ID: <1270586229.1477.665.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-06 at 16:17 -0400, H. Peter Anvin wrote:
[...]
> Therefore, the only sensible way to get the early messages out is really
> to push setup_early_printk() as early as possible.
> 
I agree. I am already testing a patch which does exactly that. I should
have it ready for review either later today or tomorrow.

On the plus side, it shows several additional early messages on the
serial console, including the linux version and the command line.

On the downside, I removed the "Kernel alive" message. I don't think
that really makes a difference, though, since I do not see how
console_loglevel can be 10 or higher by the time the message is supposed
to be generated.

Guenter


