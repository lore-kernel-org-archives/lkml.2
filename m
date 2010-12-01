Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab0LABHw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 20:07:52 -0500
Received: from kroah.org ([198.145.64.141]:45675 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752996Ab0LABHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 20:07:51 -0500
Date: Tue, 30 Nov 2010 17:07:15 -0800
From: Greg KH <greg@kroah.com>
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Luben Tuikov <ltuikov@yahoo.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [USB] UAS: Rename urbs by pipe
Message-ID: <20101201010715.GB9108@kroah.com>
References: <444316.89210.qm@web31808.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <444316.89210.qm@web31808.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 28, 2010 at 01:05:14PM -0700, Luben Tuikov wrote:
> The reason to do this is to accommodate sending
> different IU types using the existing
> infrastructure.
> 
> Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>

Matthew, it's been over a month, please comment on these UAS patches, or
I guess I'll just apply them...

thanks,

greg k-h
