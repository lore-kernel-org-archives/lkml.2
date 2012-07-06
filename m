Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030208Ab2GFXJw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 19:09:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36322 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756427Ab2GFXJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 19:09:49 -0400
Date: Fri, 6 Jul 2012 16:09:45 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jesper Juhl <jj@chaosbits.net>
Cc: devel@driverdev.osuosl.org, Marcos Paulo de Souza <marcos.mage@gmail.com>,
        Forest Bond <forest@alittletooquiet.net>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: vt6656: iwctl: mop up a few remaining obvious
 style issues
Message-ID: <20120706230945.GA8835@kroah.com>
References: <alpine.LNX.2.00.1206272116490.6908@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1206272116490.6908@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2012 at 09:19:15PM +0200, Jesper Juhl wrote:
> My previous 14 patch series to vt6656 missed a few bits and
> pieces. This mops up the last few obvious style issues.
> It is quite short and completely trivial - simply deletes a few blank
> lines, does some whitespace cleanup around operators and adds a few
> curly braces.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Again, one patch per thing please.  Please break this up into different
patches so it can be accepted.

greg k-h
