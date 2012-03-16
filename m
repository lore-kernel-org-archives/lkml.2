Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab2CPS5w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 14:57:52 -0400
Received: from mailfw02.zoner.fi ([84.34.147.249]:53743 "EHLO
	mailfw02.zoner.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754794Ab2CPS5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 14:57:51 -0400
X-Greylist: delayed 603 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Mar 2012 14:57:50 EDT
Date: Fri, 16 Mar 2012 20:47:37 +0200
From: Lasse Collin <lasse.collin@tukaani.org>
To: "Jan Beulich" <JBeulich@suse.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xz: make use of BCJ filter also for 32-bit x86 kernel
Message-ID: <20120316204737.23aacd2b@tukaani.org>
In-Reply-To: <4F621C930200007800078B9E@nat28.tlf.novell.com>
References: <4F621C930200007800078B9E@nat28.tlf.novell.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Antivirus-Scanner: Clean mail though you should still use an Antivirus
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-03-15 Jan Beulich wrote:
> The ARCH value for 32-bit x86 is not x86, but i?86.

Thanks for noticing this. Is ARCH even the correct variable to use?
Maybe SRCARCH would be better. Then it would be enough to test for x86,
if I understand the toplevel Makefile correctly.

On SPARC, it seems to be possible that ARCH is sparc32 or sparc64 while
SRCARCH is always sparc, so currently xz_wrap.sh seems to be buggy on
SPARC too.

-- 
Lasse Collin  |  IRC: Larhzu @ IRCnet & Freenode
