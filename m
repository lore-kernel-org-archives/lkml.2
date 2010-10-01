Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932493Ab0JANyg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 09:54:36 -0400
Received: from symlink.to.noone.org ([85.10.207.172]:33170 "EHLO sym.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932232Ab0JANyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 09:54:35 -0400
Date: Fri, 1 Oct 2010 15:54:34 +0200
From: Tobias Klauser <tklauser@distanz.ch>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] altera_uart: Fixup type usage of port flags
Message-ID: <20101001135434.GB10579@distanz.ch>
References: <20101001132045.GA9649@oksana.dev.rtsoft.ru> <20101001132237.GF25897@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101001132237.GF25897@oksana.dev.rtsoft.ru>
X-Editor: Vi IMproved 7.1
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-10-01 at 15:22:37 +0200, Anton Vorontsov <cbouatmailru@gmail.com> wrote:
> port->flags is of type upf_t, which corresponds to UPF_* flags.
> 
> ASYNC_BOOT_AUTOCONF is an unsigned integer, which happen to
> be the same as UPF_BOOT_AUTOCONF.
> 
> Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>

Acked-by: Tobias Klauser <tklauser@distanz.ch>
