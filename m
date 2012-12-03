Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab2LCPn7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 10:43:59 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64463 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786Ab2LCPn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 10:43:58 -0500
Date: Mon, 3 Dec 2012 15:43:54 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, Jamie Iles <jamie@jamieiles.com>,
        linux-serial@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 0/5] serial: 8250: 8250_dw changes and dynamic
 capabilities
Message-ID: <20121203154354.GB20140@page>
References: <1354533479-27306-1-git-send-email-heikki.krogerus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354533479-27306-1-git-send-email-heikki.krogerus@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Heikki,

On Mon, Dec 03, 2012 at 01:17:54PM +0200, Heikki Krogerus wrote:
> 
> Changes since v1:
> - rebased on top of Greg's tty-next
> 
> These are mainly small 8250_dw.c changes. The interesting patch is
> probable the first one that changes 8250.c so the drivers are able to
> deliver their UART's capabilities when they are registering ports.

Other than my comment on 3/5 it looks great.

Reviewed-by: Jamie Iles <jamie@jamieiles.com>

Jamie
