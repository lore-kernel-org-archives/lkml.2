Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767Ab2LDRDI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 12:03:08 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:38333 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287Ab2LDRDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 12:03:06 -0500
Date: Tue, 4 Dec 2012 17:02:58 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, Jamie Iles <jamie@jamieiles.com>,
        linux-serial@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv3 3/5] serial: 8250_dw: Map IO memory
Message-ID: <20121204170258.GA6641@page>
References: <20121204081713.GA8071@xps8300>
 <1354634512-19299-1-git-send-email-heikki.krogerus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354634512-19299-1-git-send-email-heikki.krogerus@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good to me!

On Tue, Dec 04, 2012 at 05:21:52PM +0200, Heikki Krogerus wrote:
> This needs to be done in order to later access the
> Designware specific registers.
> 
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>

Reviewed-by: Jamie Iles <jamie@jamieiles.com>
