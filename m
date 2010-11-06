Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab0KFKjn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 06:39:43 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64099 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118Ab0KFKjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 06:39:42 -0400
Date: Sat, 6 Nov 2010 10:39:35 +0000
From: James Hogan <james@albanarts.com>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 01/16 v2] pramfs: documentation
Message-ID: <20101106103935.GA13172@gandalf.local>
References: <4CD51832.7070309@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CD51832.7070309@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Nov 06, 2010 at 09:56:18AM +0100, Marco Stornelli wrote:
> From: Marco Stornelli <marco.stornelli@gmail.com>
> +PRAMFS is write protected. The page table entries that map the backing-store
> +RAM are normally marked read-only. Write operations into the filesystem
> +temporarily mark the affected pages as writeable, the write operation is
> +carried out with locks held, and then the page table entries is +marked read-only again.
> +This feature provides protection against filesystem corruption caused by errant

Looks like an accidental lost newline in the patch here, should that be
"are marked" or is there some text missing?

Cheers
James
