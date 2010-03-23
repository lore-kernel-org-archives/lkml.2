Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab0CWVzP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 17:55:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56777 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754462Ab0CWVzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 17:55:11 -0400
Date: Tue, 23 Mar 2010 14:54:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tobias Klauser <tklauser@distanz.ch>
Cc: linux-serial@vger.kernel.org, gregkh@suse.de,
       nios2-dev@sopc.et.ntust.edu.tw, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 2/2] serial: Add driver for the Altera UART
Message-Id: <20100323145459.9894b1e6.akpm@linux-foundation.org>
In-Reply-To: <a596efa5dc6130a27d045ea24174c792ee2f0bb4.1267807169.git.klto@zhaw.ch>
References: <cover.1267807169.git.klto@zhaw.ch>
	<15dc056891fb785001073bab4f9a0d0f3bf99af1.1267807169.git.klto@zhaw.ch>
	<a596efa5dc6130a27d045ea24174c792ee2f0bb4.1267807169.git.klto@zhaw.ch>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  5 Mar 2010 17:52:23 +0100
Tobias Klauser <tklauser@distanz.ch> wrote:

> +	sigs |= (altera_uart_getppdcd(port->line) ? TIOCM_CD : 0);
> +	sigs |= (altera_uart_getppdtr(port->line) ? TIOCM_DTR : 0);

We seem to be missing a few things here.

drivers/serial/altera_uart.c: In function 'altera_uart_get_mctrl':
drivers/serial/altera_uart.c:100: error: implicit declaration of function 'altera_uart_getppdcd'
drivers/serial/altera_uart.c:101: error: implicit declaration of function 'altera_uart_getppdtr'
drivers/serial/altera_uart.c: In function 'altera_uart_set_mctrl':
drivers/serial/altera_uart.c:114: error: implicit declaration of function 'altera_uart_setppdtr'                                                                                                                                                                              
