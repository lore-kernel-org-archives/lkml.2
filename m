Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757160Ab2EBUN1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 16:13:27 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47483 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756738Ab2EBUN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 16:13:26 -0400
Date: Wed, 2 May 2012 13:13:21 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] extcon: Add EXTCON_MECHANICAL cable type for physical
 presence
Message-ID: <20120502201321.GA26275@kroah.com>
References: <1335951531-5967-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335951531-5967-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2012 at 10:38:51AM +0100, Mark Brown wrote:
> Some accessory detection mechanisms are able to detect that something is
> physically present in the socket separately to identifying what is present
> in the socket. This information can be useful to applications, for example
> allowing them to indicate that a potentially broken accessory is present,
> so provide a standard way to report it to userspace.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/extcon/extcon_class.c |    1 +
>  include/linux/extcon.h        |    1 +
>  2 files changed, 2 insertions(+)

Ok, but where is the in-kernel user of this new interface?  Why are we
adding it now before someone actually needs it?

And shouldn't this also update some documentation somewhere as well?

thanks,

greg k-h
