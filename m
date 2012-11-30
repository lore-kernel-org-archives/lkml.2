Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933043Ab2K3NtE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 08:49:04 -0500
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:38349 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197Ab2K3NtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 08:49:02 -0500
Date: Fri, 30 Nov 2012 15:48:58 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Cox <alan@linux.intel.com>, Jamie Iles <jamie@jamieiles.com>,
        linux-serial@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] serial: 8250: 8250_dw changes and dynamic
 capabilities
Message-ID: <20121130134858.GA12481@as23.pp.htv.fi>
References: <1354106924-11013-1-git-send-email-heikki.krogerus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354106924-11013-1-git-send-email-heikki.krogerus@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 02:48:39PM +0200, Heikki Krogerus wrote:
> Hi,
> 
> These are mainly small changes to 8250_dw.c. The interesting patch is
> probable the addition to 8250.c that would allow the drivers to
> deliver their UART's capabilities when they are registering ports.

These don't apply on top of tty-next so I need to make version two.
I'll send it next week in case somebody has comments.

-- 
heikki
