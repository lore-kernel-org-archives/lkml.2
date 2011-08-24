Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600Ab1HXWBJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 18:01:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43170 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803Ab1HXWBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 18:01:07 -0400
Date: Wed, 24 Aug 2011 14:54:38 -0700
From: Greg KH <gregkh@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Arnd Bergmann <arnd@arndb.de>, alan@linux.intel.com,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        linux-m68k@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: patch "TTY: remove tty_locked" added to tty tree
Message-ID: <20110824215438.GA1025@suse.de>
References: <13141210141189@kroah.org>
 <201108241320.47635.arnd@arndb.de>
 <4E54E4D9.6070802@suse.cz>
 <201108241635.13502.arnd@arndb.de>
 <4E556CB7.2010102@suse.cz>
 <20110824214201.GB30829@suse.de>
 <4E5571A6.6050705@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E5571A6.6050705@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 11:48:22PM +0200, Jiri Slaby wrote:
> On 08/24/2011 11:42 PM, Greg KH wrote:
> > So, is your original patch you sent in this thread still needed?
> 
> If you mean "TTY: remove tty_locked", then yes, it's fine to see
> tty_locked go.

Good, that's already in my tree :)

> It looks like we won't need it to fix the stalls in the end. If you
> mean TTY-fix-stalls-on-BTM-when-waiting-until-sent, that one will be
> superseded by a new one.

Ok, I'll wait for that one then, thanks.

greg k-h
