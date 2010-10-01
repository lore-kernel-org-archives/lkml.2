Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894Ab0JAN5r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 09:57:47 -0400
Received: from symlink.to.noone.org ([85.10.207.172]:40055 "EHLO sym.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756087Ab0JAN5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 09:57:46 -0400
Date: Fri, 1 Oct 2010 15:57:45 +0200
From: Tobias Klauser <tklauser@distanz.ch>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] altera_uart: Add support for polling mode
	(IRQ-less)
Message-ID: <20101001135745.GC10579@distanz.ch>
References: <20101001132045.GA9649@oksana.dev.rtsoft.ru> <20101001132133.GB25897@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101001132133.GB25897@oksana.dev.rtsoft.ru>
X-Editor: Vi IMproved 7.1
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-10-01 at 15:21:33 +0200, Anton Vorontsov <cbouatmailru@gmail.com> wrote:
> Some Altera UART implementations doesn't route the IRQ line, so we have
> to work in polling mode.
> 
> Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>

Acked-by: Tobias Klauser <tklauser@distanz.ch>

Thanks a lot.
