Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761993Ab2KAPiu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 11:38:50 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:33565 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757780Ab2KAPir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 11:38:47 -0400
MIME-Version: 1.0
X-Originating-IP: [59.167.234.130]
In-Reply-To: <1351621520-17768-3-git-send-email-behanw@converseincode.com>
References: <1351621520-17768-1-git-send-email-behanw@converseincode.com>
	<1351621520-17768-3-git-send-email-behanw@converseincode.com>
Date: Fri, 2 Nov 2012 02:38:46 +1100
Message-ID: <CAOzFzEhpFToEvnfEHvQyX3yuoSR5ABDd9TMQ9_W97GKdLTc1eQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] Remove VLAIS usage from gadget code
From: Joseph Glanville <joseph.glanville@orionvm.com.au>
To: Behan Webster <behanw@converseincode.com>
Cc: balbi@ti.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 October 2012 05:25, Behan Webster <behanw@converseincode.com> wrote:
> The use of variable length arrays in structs (VLAIS) in the Linux Kernel code
> precludes the use of compilers which don't implement VLAIS (for instance the
> Clang compiler). This patch instead calculates offsets into the kmalloc-ed
> memory buffer using macros from valign.h.
>
> Signed-off-by: Behan Webster <behanw@converseincode.com>

Linux only lists 2 requirements in the README.

1. GCC
2. PMMU ( granted this implies a much bigger list of requirements. :P )

Deficiences in Clangs GCC compatibility mode should be addressed
rather than pointlessly changing kernel code.
Possibly propose a patch to Clang instead?

Joseph.

-- 
CTO | Orion Virtualisation Solutions | www.orionvm.com.au
Phone: 1300 56 99 52 | Mobile: 0428 754 846
