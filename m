Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172Ab0I2Fk0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 01:40:26 -0400
Received: from symlink.to.noone.org ([85.10.207.172]:53082 "EHLO sym.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751357Ab0I2FkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 01:40:24 -0400
Date: Wed, 29 Sep 2010 07:40:23 +0200
From: Tobias Klauser <tklauser@distanz.ch>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] altera_uart: Make it possible to use Altera UART
	and 8250 ports together
Message-ID: <20100929054023.GG3137@distanz.ch>
References: <20100928133545.GE8289@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100928133545.GE8289@oksana.dev.rtsoft.ru>
X-Editor: Vi IMproved 7.1
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-09-28 at 15:35:45 +0200, Anton Vorontsov <cbouatmailru@gmail.com> wrote:
> This fixes tty name and major number conflicts. The major number
> 204 is used across many platform-specific serial drivers, so we
> use that.
> 
> Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>

Acked-by: Tobias Klauser <tklauser@distanz.ch>
