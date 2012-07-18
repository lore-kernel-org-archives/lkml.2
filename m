Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757989Ab2GRAPS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 20:15:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40672 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757954Ab2GRAOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 20:14:19 -0400
Date: Tue, 17 Jul 2012 17:14:14 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dave Jones <davej@redhat.com>
Subject: Re: [ 01/37] Remove easily user-triggerable BUG from generic_setlease
Message-ID: <20120718001414.GA17973@kroah.com>
References: <20120717232455.GA5994@kroah.com>
 <20120717232431.399005532@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120717232431.399005532@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 05:02:38PM -0700, Greg Kroah-Hartman wrote:
> From: Greg KH <gregkh@linuxfoundation.org>
> 
> 3.4-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------

Argh, I give up, I just can't get message threading working properly
these days.  These are the 3.4 patches, in response to the 3.0 patches,
and it took 2 tries to send them out due to formail doing wierd things.

Sorry about this people, I'll just give up and use 'git send-email' from
now on, as it doesn't cause as many problems as my old scripts seem to.

greg k-h
