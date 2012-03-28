Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933352Ab2C1XbR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 19:31:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58927 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933171Ab2C1XbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 19:31:12 -0400
Date: Wed, 28 Mar 2012 16:31:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, Len Brown <len.brown@intel.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH v3] x86: Remove deprecated disable_hlt and enable_hlt
Message-Id: <20120328163110.a8f0e9ba.akpm@linux-foundation.org>
In-Reply-To: <20120328150300.GH1997@zod.bos.redhat.com>
References: <20120328150300.GH1997@zod.bos.redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Mar 2012 11:03:00 -0400
Josh Boyer <jwboyer@redhat.com> wrote:

> From: Len Brown <lenb@intel.com>

Nope, it's lenb@kernel.org and/or len.brown@intel.com.

I've been using both addresses for Len lately - I think some people's
@kernel.org addresses are now dead.  I don't know about Len, but mine
has died and I haven't set about working out how to resurrect it.

> The X86_32-only disable_hlt/enable_hlt mechanism was used by the 32-bit
> floppy driver. Its effect was to replace the use of the HLT instruction
> inside default_idle() with cpu_relax().

