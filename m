Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759494Ab2JKWTa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 18:19:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46472 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632Ab2JKWT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 18:19:27 -0400
Date: Thu, 11 Oct 2012 15:19:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: James Morris <jmorris@namei.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Kent Yoder <key@linux.vnet.ibm.com>
Subject: Re: [GIT] TPM bugfixes
Message-Id: <20121011151925.5fcafe7c.akpm@linux-foundation.org>
In-Reply-To: <alpine.LRH.2.02.1210112153030.9640@tundra.namei.org>
References: <alpine.LRH.2.02.1210112153030.9640@tundra.namei.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Oct 2012 21:54:18 +1100 (EST)
James Morris <jmorris@namei.org> wrote:

> Please pull these fixes for the TPM code.
> 
> The following changes since commit 12250d843e8489ee00b5b7726da855e51694e792:
> 
>   Merge branch 'i2c-embedded/for-next' of git://git.pengutronix.de/git/wsa/linux (2012-10-11 10:27:51 +0900)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git for-linus

Gargh.  Is it possible to add a human-readable http URL to these things
so that people can actually look at the patches without hoop-jumping? 

> Peter Huewe (1):
>       tpm: Propagate error from tpm_transmit to fix a timeout hang

Did this one get the -stable tag added to it?
