Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab2GaRBR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 13:01:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35801 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab2GaRA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 13:00:57 -0400
Date: Tue, 31 Jul 2012 10:00:52 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>, Dave Jones <davej@redhat.com>,
        Jan Kara <jack@suse.cz>, Andy Isaacson <adi@hexapodia.org>,
        Nai Xia <nai.xia@gmail.com>, Johannes Weiner <jweiner@redhat.com>
Subject: Re: [ 28/41] mm: compaction: introduce sync-light migration for use
 by compaction
Message-ID: <20120731170052.GA8812@kroah.com>
References: <20120730172901.306897424@linuxfoundation.org>
 <20120730172903.507239700@linuxfoundation.org>
 <20120731164333.GE3111@herton-Z68MA-D2H-B3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120731164333.GE3111@herton-Z68MA-D2H-B3>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 01:43:37PM -0300, Herton Ronaldo Krzesinski wrote:
> On Mon, Jul 30, 2012 at 10:31:27AM -0700, Greg Kroah-Hartman wrote:
> > From: Greg KH <gregkh@linuxfoundation.org>
> > 
> > 3.0-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Mel Gorman <mgorman@suse.de>
> > 
> > commit a6bc32b899223a877f595ef9ddc1e89ead5072b8 upstream.
> 
> We need also to pick recent fix dc32f63453f56d07a1073a697dcd843dd3098c09
> after applying this one.

Thanks, I'll queue that up for the next round of kernels, given that
people have lived with the problem up until now :)

greg k-h
