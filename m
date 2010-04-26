Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab0DZUrW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 16:47:22 -0400
Received: from cantor.suse.de ([195.135.220.2]:52191 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755198Ab0DZUrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 16:47:21 -0400
Date: Mon, 26 Apr 2010 13:46:53 -0700
From: Greg KH <gregkh@suse.de>
To: Mike Travis <travis@sgi.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Pavel Machek <pavel@ucw.cz>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Rik van Riel <riel@redhat.com>,
       John Stoffel <john@stoffel.org>, Hedi Berriche <hedi@sgi.com>,
       Jack Steiner <steiner@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, Robin Holt <holt@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch 1/1] init: Provide a kernel start parameter to increase
 pid_max v3
Message-ID: <20100426204648.GC30736@suse.de>
References: <20100421193350.GU16427@zorg.emea.sgi.com>
 <19407.23456.469074.256306@stoffel.org>
 <20100421222414.GA26241@suse.de>
 <4BCF80F2.2010906@redhat.com>
 <20100421232200.GA22877@suse.de>
 <20100422102852.72837494@lxorguk.ukuu.org.uk>
 <alpine.LFD.2.00.1004220743080.9086@i5.linux-foundation.org>
 <20100425071606.GB1275@ucw.cz>
 <alpine.LFD.2.00.1004251002480.3739@i5.linux-foundation.org>
 <4BD5EDF9.6030504@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BD5EDF9.6030504@sgi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 26, 2010 at 12:48:09PM -0700, Mike Travis wrote:
> Subject: [Patch 1/1] init: Provide a kernel start parameter to increase pid_max v3

Your subject is now incorrect, based on the patch.  You should also
adjust the body of the changelog to reflect the code change.

thanks,

greg k-h
