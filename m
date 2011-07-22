Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab1GVPYL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 11:24:11 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:56490 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754729Ab1GVPYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 11:24:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=CEnOjAh66IAwwwudMuebRT9R1RvTrH7b33OEoBOheGxoB3GqH41jwfDXqIXwmnG5yw7VEezhQHrRrfVcy7/XxnS7uYJz9BZLNLdck9WyvX69pySZrFdOVZzv4f3sdgI7;
Date: Fri, 22 Jul 2011 08:24:04 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Jan Beulich" <JBeulich@novell.com>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: constify PCI raw ops structures
Message-ID: <20110722082404.46b748ed@jbarnes-desktop>
In-Reply-To: <4E258C82020000780004E3C2@nat28.tlf.novell.com>
References: <4E258C82020000780004E3C2@nat28.tlf.novell.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jul 2011 12:54:10 +0100
"Jan Beulich" <JBeulich@novell.com> wrote:

> As with any other such change, the goal is to prevent inadvertent
> writes to these structures (assuming DEBUG_RODATA is enabled), and to
> separate data (possibly frequently) written to from such never getting
> modified.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> 
> ---
>  arch/x86/include/asm/pci_x86.h |    6 +++---
>  arch/x86/pci/ce4100.c          |    2 +-
>  arch/x86/pci/common.c          |    4 ++--
>  arch/x86/pci/direct.c          |    6 +++---
>  arch/x86/pci/mmconfig_32.c     |    2 +-
>  arch/x86/pci/mmconfig_64.c     |    2 +-
>  arch/x86/pci/numaq_32.c        |    2 +-
>  arch/x86/pci/olpc.c            |    2 +-
>  arch/x86/pci/pcbios.c          |    4 ++--
>  9 files changed, 15 insertions(+), 15 deletions(-)

Applied, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
