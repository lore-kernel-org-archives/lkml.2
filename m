Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483Ab2JMMhA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 08:37:00 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:56603 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753390Ab2JMMg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 08:36:58 -0400
Message-ID: <1350131814.2485.46.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH 16/25] parisc: Use Kbuild infrastructure to handle
 asm-generic headers
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>
Date: Sat, 13 Oct 2012 13:36:54 +0100
In-Reply-To: <20121013022954.722147403@goodmis.org>
References: <20121013022632.024527228@goodmis.org>
	 <20121013022954.722147403@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-12 at 22:26 -0400, Steven Rostedt wrote:
> plain text document attachment
> (0016-parisc-Use-Kbuild-infrastructure-to-handle-asm-gener.patch)
> From: Steven Rostedt <srostedt@redhat.com>
> 
> Use Kbuild infrastructure to handle the asm-generic headers
> and remove the wrapper headers that call them.
> 
> This only affects headers that do nothing but include the generic
> equivalent. It does not touch any header that does a little more.
> 
> Cc: linux-kbuild@vger.kernel.org
> Cc: linux-parisc@vger.kernel.org
> Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
> Cc: Helge Deller <deller@gmx.de>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Actually, we're already evaluating a patch like this:

http://marc.info/?l=linux-kernel&m=134883983019018

When I compare the two, I notice you missed a few (segment.h, vga.h,
hw_irq.h, mutex.h), so you probably want to adjust your scripts.

James


