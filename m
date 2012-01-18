Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894Ab2ARPCJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 10:02:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36112 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757852Ab2ARPCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 10:02:08 -0500
Date: Wed, 18 Jan 2012 07:00:15 -0800
From: Greg KH <gregkh@suse.de>
To: leonid.moiseichuk@nokia.com
Cc: penberg@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        cesarb@cesarb.net, kamezawa.hiroyu@jp.fujitsu.com, emunson@mgebm.net,
        aarcange@redhat.com, riel@redhat.com, mel@csn.ul.ie,
        rientjes@google.com, dima@android.com, rebecca@android.com,
        san@google.com, akpm@linux-foundation.org, vesa.jaaskelainen@nokia.com
Subject: Re: [PATCH v2 1/2] Making si_swapinfo exportable
Message-ID: <20120118150015.GB18315@suse.de>
References: <cover.1326803859.git.leonid.moiseichuk@nokia.com>
 <56cc3c5d40a8653b7d9bef856ff02d909b98f36f.1326803859.git.leonid.moiseichuk@nokia.com>
 <CAOJsxLHfHHrFyhfkSe8mbsnJHBkgKtksCZZDwN6K3d7KJqfzkQ@mail.gmail.com>
 <20120118140904.GB13817@suse.de>
 <84FF21A720B0874AA94B46D76DB98269045599D8@008-AM1MPN1-003.mgdnok.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84FF21A720B0874AA94B46D76DB98269045599D8@008-AM1MPN1-003.mgdnok.nokia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 02:47:47PM +0000, leonid.moiseichuk@nokia.com wrote:
> > -----Original Message-----
> > From: ext Greg KH [mailto:gregkh@suse.de]
> > Sent: 18 January, 2012 16:09
> ...
> 
> > > > +EXPORT_SYMBOL(si_swapinfo);
> > 
> > EXPORT_SYMBOL_GPL() perhaps?
> 
> I followed si_meminfo which is uses EXPORT_SYMBOL.

Ah, good point.
