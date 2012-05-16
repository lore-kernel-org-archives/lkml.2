Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720Ab2EPPp7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 11:45:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55382 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752819Ab2EPPp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 11:45:57 -0400
Date: Wed, 16 May 2012 18:41:04 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: x86@kernel.org, kvm@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        gleb@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 0/5] apic: eoi optimization support
Message-ID: <20120516154103.GA10320@redhat.com>
References: <cover.1337168687.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1337168687.git.mst@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 02:45:50PM +0300, Michael S. Tsirkin wrote:
> I'm looking at reducing the interrupt overhead for virtualized guests:
> some workloads spend a large part of their time processing interrupts.
> This patchset supplies infrastructure to reduce the IRQ ack overhead on
> x86: the idea is to add an eoi_write callback that we can then optimize
> without touching other apic functionality.

Ugh. I lost first part of the patchset.
Sorry.
Will send a fixed one now.
