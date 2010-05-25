Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089Ab0EYGF2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 02:05:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53361 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752835Ab0EYGF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 02:05:27 -0400
Date: Mon, 24 May 2010 23:05:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Frantisek Hanzlik <franta@hanzlici.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: fs/fs-writeback oopses in kernel 2.6.33.4-95.fc13.i686.PAE
Message-Id: <20100524230512.8cc7dfc1.akpm@linux-foundation.org>
In-Reply-To: <4BFA730C.1010906@hanzlici.cz>
References: <4BFA730C.1010906@hanzlici.cz>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 May 2010 14:37:32 +0200 Frantisek Hanzlik <franta@hanzlici.cz> wrote:

> Hello,
> I upgrade from kernel 2.6.33.3 to 2.6.33.4 (2.6.33.4-95.fc13.i686.PAE, 
> Fedora 13 distro) and now I see several these messages every day in 
> /var/log/messages:
> 
> May 24 14:01:32 ns kernel: ------------[ cut here ]------------
> May 24 14:01:32 ns kernel: WARNING: at fs/fs-writeback.c:597 
> writeback_inodes_wb+0x202/0x30e()

I don't see anything which would generate this warning in 2.6.33.4's
fs/fs-writeback.c:597.  RH must have mucked with it.

