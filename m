Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280Ab2GQCJQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 22:09:16 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52385 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066Ab2GQCJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 22:09:14 -0400
Date: Mon, 16 Jul 2012 19:09:10 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org,
        abbotti@mev.co.uk
Subject: Re: [PATCH 2/2] staging: comedi: remove the devpriv and thisboard
 macros
Message-ID: <20120717020910.GA469@kroah.com>
References: <201207121747.21955.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201207121747.21955.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2012 at 05:47:21PM -0700, H Hartley Sweeten wrote:
> The macros 'devpriv' and 'thisboard' rely on a local variable having
> a specific name and yeild pointers derived from that variable. Replace
> the macros with local variables where used and use to comedi_board()
> helper to get the 'thisboard' pointer.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Ian Abbott <abbotti@mev.co.uk>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Because I didn't take your other large patch series, this one didn't
apply :(

greg k-h
