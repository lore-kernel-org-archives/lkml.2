Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965115Ab2FAP4I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 11:56:08 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:49168 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965085Ab2FAP4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 11:56:01 -0400
Date: Fri, 1 Jun 2012 15:05:07 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Joakim Tjernlund <Joakim.Tjernlund@transmode.se>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [ 71/94] spi/spi-fsl-spi: reference correct pdata in
 fsl_spi_cs_control
Message-ID: <20120601070507.GD13229@kroah.com>
References: <20120527010332.GA11170@kroah.com>
 <20120527010433.768465216@linuxfoundation.org>
 <20120528194437.GC2915@herton-Z68MA-D2H-B3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120528194437.GC2915@herton-Z68MA-D2H-B3>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2012 at 04:44:38PM -0300, Herton Ronaldo Krzesinski wrote:
> On Sun, May 27, 2012 at 10:05:34AM +0900, Greg KH wrote:
> > 3.3-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> 
> In addition to this fix, please also cherry-pick into 3.3 series commit
> 5039a86973cd35bdb2f64d28ee12f13fe2bb5a4c, "spi/mpc83xx: fix NULL pdata
> dereference bug". I noted now that 3.3 stable is missing it. It
> was the first part addressing the issue introduced by commit 178db7d3 in
> spi-fsl-spi, that is included in 3.3.

Now applied, thanks.

greg k-h
