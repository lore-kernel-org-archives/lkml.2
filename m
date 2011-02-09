Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824Ab1BIJx3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 04:53:29 -0500
Received: from symlink.to.noone.org ([85.10.207.172]:52629 "EHLO sym.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753429Ab1BIJx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 04:53:27 -0500
Date: Wed, 9 Feb 2011 10:53:26 +0100
From: Tobias Klauser <tklauser@distanz.ch>
To: Greg Kroah-Hartman <gregkh@suse.de>, linux-serial@vger.kernel.org
Cc: nios2-dev@sopc.et.ntust.edu.tw, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] *** SUBJECT HERE ***
Message-ID: <20110209095326.GT29757@distanz.ch>
References: <cover.1297244810.git.tklauser@distanz.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1297244810.git.tklauser@distanz.ch>
X-Editor: Vi IMproved 7.1
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-02-09 at 10:51:10 +0100, Tobias Klauser <tklauser@distanz.ch> wrote:
> *** BLURB HERE ***

Sorry for this mess. I've accidentialy overwritten my original cover
letter. Will send again with the correct subject and text (and better
test my submissions in the future).

> 
> Tobias Klauser (4):
>   tty: serial: altera_uart: Handle pdev->id == -1 in altera_uart_remove
>   tty: serial: altera_uart: Use port->regshift to store bus shift
>   tty: serial: altera_uart: Add devicetree support
>   MAINTAINERS: Add myself as a maintainer for
>     altera_uart/altera_jtaguart
> 
>  .../devicetree/bindings/serial/altera_uart.txt     |    7 ++
>  MAINTAINERS                                        |   10 +++
>  drivers/tty/serial/altera_uart.c                   |   69 ++++++++++++++++----
>  3 files changed, 74 insertions(+), 12 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/serial/altera_uart.txt
> 
