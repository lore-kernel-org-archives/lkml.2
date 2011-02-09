Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab1BIKql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 05:46:41 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52172 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524Ab1BIKqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 05:46:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=myb2DqlmVFgkzKPYvOuO0pZOQGjHZlTfFrpnD2gvSRPHT3MIuqO73frM2pM3nBgiIg
         CTYQW2uLiKsvAhF6V2+mE9XazyIwP3lEtolrp7IP4c7+W4VMi68oce69PVa8wtXOo21M
         xXZv1gBL/8isQwcfqdfcfOoatMkavn132NizE=
Date: Wed, 9 Feb 2011 13:46:35 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Tobias Klauser <tklauser@distanz.ch>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-serial@vger.kernel.org,
        nios2-dev@sopc.et.ntust.edu.tw, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] tty: serial: altera_uart: Use port->regshift to
 store bus shift
Message-ID: <20110209104635.GB21588@oksana.dev.rtsoft.ru>
References: <cover.1297245277.git.tklauser@distanz.ch>
 <6ced1dcb96fc56fcdc8fb0daab898a773a7a320c.1297245277.git.tklauser@distanz.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6ced1dcb96fc56fcdc8fb0daab898a773a7a320c.1297245277.git.tklauser@distanz.ch>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 09, 2011 at 10:57:04AM +0100, Tobias Klauser wrote:
> Use the regshift member of struct uart_port to store the address stride
> from platform data. This way we can save one dereference per call of
> altera_uart_readl and altera_uart_writel.
> 
> This also allows us to use the driver without platform data, which is
> needed for device tree support in the Nios2 port.
> 
> Cc: Anton Vorontsov <cbouatmailru@gmail.com>
> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>

Acked-by: Anton Vorontsov <cbouatmailru@gmail.com>

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
