Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995Ab0IYRdP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 13:33:15 -0400
Received: from cantor.suse.de ([195.135.220.2]:53142 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753597Ab0IYRdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 13:33:14 -0400
Date: Sat, 25 Sep 2010 10:34:01 -0700
From: Greg KH <gregkh@suse.de>
To: Rahul Ruikar <rahul.ruikar@gmail.com>
Cc: jirislaby@gmail.com, ak@linux.intel.com, adobriyan@gmail.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] misc: phantom: Added missing warning messages in
	phantom_probe
Message-ID: <20100925173401.GA5474@suse.de>
References: <1285422505-7128-1-git-send-email-rahul.ruikar@gmail.com> <AANLkTik-1noL87D7dnq8AzV9i9BfxYoa-KboAB15r=oT@mail.gmail.com> <20100925150415.GA4124@suse.de> <AANLkTinnRFCRpfZwTTsCNtJa8s_HFhv=toORXjT_5p1e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinnRFCRpfZwTTsCNtJa8s_HFhv=toORXjT_5p1e@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 25, 2010 at 10:57:08PM +0530, Rahul Ruikar wrote:
> Greg,
> 
> Actually before sending patch I run get_maintainer.pl script against
> this patch and  it gave me all following names..
> that was reason i added you in maill.
> 
> [rahul@Ganesha linux-2.6]$ ./scripts/get_maintainer.pl
> 0001-misc-phantom-Added-missing-warning-messages-in-phant.patch
> Jiri Slaby <jirislaby@gmail.com>
> Andi Kleen <ak@linux.intel.com>
> Alexey Dobriyan <adobriyan@gmail.com>
> Greg Kroah-Hartman <gregkh@suse.de>
> Andrew Morton <akpm@linux-foundation.org>
> Rahul Ruikar <rahul.ruikar@gmail.com>
> linux-kernel@vger.kernel.org

Ah, ok, that makes more sense, thanks.

greg k-h
