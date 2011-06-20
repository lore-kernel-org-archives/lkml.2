Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113Ab1FTW3a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 18:29:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33883 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755338Ab1FTW30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 18:29:26 -0400
Date: Mon, 20 Jun 2011 15:28:27 -0700
From: Greg KH <gregkh@suse.de>
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable-review@kernel.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [00/91] 2.6.32.42-longterm review
Message-ID: <20110620222827.GA25088@suse.de>
References: <20110616001900.GA25375@kroah.com>
 <20110617203649.GA29317@nik-comp.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110617203649.GA29317@nik-comp.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 17, 2011 at 10:36:49PM +0200, Nikola Ciprich wrote:
> Hi Greg,
> seems like only first 55 mails made it to the list, also the link seems to be wrong...

I forgot to put the correct link in the email, it should be obvious as
to what it should be.

> maybe some bug in the script?

Probably, some people pointed out a problem that I had with the Subject:
on some patches, which was caused by a git update and my scripts not
properly handling multi-line Subject: lines in emails.

I'll fix that up for next time.

thanks,

greg k-h
