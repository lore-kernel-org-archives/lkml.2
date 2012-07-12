Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161599Ab2GLVfV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 17:35:21 -0400
Received: from mail.vyatta.com ([76.74.103.46]:60843 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964791Ab2GLVfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 17:35:18 -0400
Date: Thu, 12 Jul 2012 14:35:02 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: "Piotr Sawuk" <a9702387@unet.univie.ac.at>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: resurrecting tcphealth
Message-ID: <20120712143502.3f9fa5bf@nehalam.linuxnetplumber.net>
In-Reply-To: <dee325378a2d3b7792da9640fc14905f.squirrel@webmail.univie.ac.at>
References: <dee325378a2d3b7792da9640fc14905f.squirrel@webmail.univie.ac.at>
Organization: Vyatta
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jul 2012 22:55:57 +0200
"Piotr Sawuk" <a9702387@unet.univie.ac.at> wrote:

> diff -rub linux-3.4.4/net/ipv4/tcp_input.c
> linux-3.4.4-heal-lsm/net/ipv4/tcp_input.c
> --- linux-3.4.4/net/ipv4/tcp_input.c	2012-06-22 20:37:50.000000000 +0200
> +++ linux-3.4.4-heal-lsm/net/ipv4/tcp_input.c	2012-07-06
> 10:12:12.000000000 +0200
> @@ -59,7 +59,8 @@
>   *		Panu Kuhlberg:		Experimental audit of TCP (re)transmission
>   *					engine. Lots of bugs are found.
>   *		Pasi Sarolahti:		F-RTO for dealing with spurious RTOs
> - */
> + *		Federico D. Sacerdoti:	Added TCP health monitoring.

Please don't do this.
The kernel community no longer maintains a list of contributors
in the comments. The history is maintained in the git commit log.
