Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936Ab1AYQ7H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 11:59:07 -0500
Received: from imap.ru.mvista.com ([213.79.90.228]:19140 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751379Ab1AYQ7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 11:59:05 -0500
X-Greylist: delayed 1865 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Jan 2011 11:59:05 EST
Date: Tue, 25 Jan 2011 19:27:56 +0300
From: Anton Vorontsov <avorontsov@mvista.com>
To: Tobias Klauser <tklauser@distanz.ch>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] tty: serial: altera_uart: remove
 early_altera_uart_setup
Message-ID: <20110125144529.GA4804@oksana.dev.rtsoft.ru>
References: <1295966417-11306-1-git-send-email-tklauser@distanz.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1295966417-11306-1-git-send-email-tklauser@distanz.ch>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 03:40:17PM +0100, Tobias Klauser wrote:
> The function has no users inside the tree and the nios2 architecture
> doesn't use it (anymore) either.
> 
> Cc: Anton Vorontsov <cbouatmailru@gmail.com>
> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
> ---

We don't use it either, at least so far. If/whenever we need it,
we can always revert this commit. So,

Acked-by: Anton Vorontsov <cbouatmailru@gmail.com>

Thanks!
