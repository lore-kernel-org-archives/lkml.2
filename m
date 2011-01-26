Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab1AZSSc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 13:18:32 -0500
Received: from symlink.to.noone.org ([85.10.207.172]:46131 "EHLO sym.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753794Ab1AZSSb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 13:18:31 -0500
Date: Wed, 26 Jan 2011 19:18:30 +0100
From: Tobias Klauser <tklauser@distanz.ch>
To: Greg Kroah-Hartman <gregkh@suse.de>, linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] tty: serial: altera_uart: add devicetree support
Message-ID: <20110126181829.GD29757@distanz.ch>
References: <1295966417-11306-1-git-send-email-tklauser@distanz.ch> <1295967457-11876-1-git-send-email-tklauser@distanz.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295967457-11876-1-git-send-email-tklauser@distanz.ch>
X-Editor: Vi IMproved 7.1
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-01-25 at 15:57:37 +0100, Tobias Klauser <tklauser@distanz.ch> wrote:
> Allow to retreive resources from a device tree (currently used in the
> out-of-tree nios2 architecture port only).
> 
> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
> ---
>  drivers/tty/serial/altera_uart.c |   16 +++++++++++++---
>  1 files changed, 13 insertions(+), 3 deletions(-)

Please disregard this patch. The driver will need more changes to
properly support retreiving everything it needs from device tree.

Sorry for the noise.
