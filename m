Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312Ab0JANww (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 09:52:52 -0400
Received: from symlink.to.noone.org ([85.10.207.172]:33100 "EHLO sym.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756703Ab0JANwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 09:52:50 -0400
Date: Fri, 1 Oct 2010 15:52:49 +0200
From: Tobias Klauser <tklauser@distanz.ch>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/8] altera_uart: Fix missing prototype for registering
	an early console
Message-ID: <20101001135249.GA10579@distanz.ch>
References: <20101001132045.GA9649@oksana.dev.rtsoft.ru> <20101001132255.GG25897@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101001132255.GG25897@oksana.dev.rtsoft.ru>
X-Editor: Vi IMproved 7.1
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-10-01 at 15:22:55 +0200, Anton Vorontsov <cbouatmailru@gmail.com> wrote:
> Simply add an early_altera_uart_setup() prototype declaration, otherwise
> platform code have to do it in .c files, which is ugly.
> 
> Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>

Acked-by: Tobias Klauser <tklauser@distanz.ch>
