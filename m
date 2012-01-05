Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291Ab2AEAbr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 19:31:47 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:55761 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932119Ab2AEAbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 19:31:41 -0500
X-Sasl-enc: aeBpqQl6bsWcWGCGTiNXZDIpWC38Rw6v8wEecf6jI71Q 1325723500
Date: Wed, 4 Jan 2012 16:24:09 -0800
From: Greg KH <greg@kroah.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] tty: move pty count limiting into devpts
Message-ID: <20120105002409.GA30083@kroah.com>
References: <20120102172254.11535.2653.stgit@zurg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120102172254.11535.2653.stgit@zurg>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 02, 2012 at 09:22:54PM +0400, Konstantin Khlebnikov wrote:
> Let's move this stuff to the better place, where we can account pty right in
> tty-indexes managing code.
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>

This doesn't apply to the tty-next branch at all.  Care to redo it and
resend it, and the 2/2 patch in this series?

thanks,

greg k-h
