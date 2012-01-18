Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757920Ab2ARPU5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 10:20:57 -0500
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:47581 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757786Ab2ARPUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 10:20:55 -0500
Subject: Re: [PATCH v2 1/2] Making si_swapinfo exportable
From: Pekka Enberg <penberg@kernel.org>
To: Greg KH <gregkh@suse.de>
Cc: leonid.moiseichuk@nokia.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, cesarb@cesarb.net,
        kamezawa.hiroyu@jp.fujitsu.com, emunson@mgebm.net, aarcange@redhat.com,
        riel@redhat.com, mel@csn.ul.ie, rientjes@google.com, dima@android.com,
        rebecca@android.com, san@google.com, akpm@linux-foundation.org,
        vesa.jaaskelainen@nokia.com
In-Reply-To: <20120118150015.GB18315@suse.de>
References: <cover.1326803859.git.leonid.moiseichuk@nokia.com>
	 <56cc3c5d40a8653b7d9bef856ff02d909b98f36f.1326803859.git.leonid.moiseichuk@nokia.com>
	 <CAOJsxLHfHHrFyhfkSe8mbsnJHBkgKtksCZZDwN6K3d7KJqfzkQ@mail.gmail.com>
	 <20120118140904.GB13817@suse.de>
	 <84FF21A720B0874AA94B46D76DB98269045599D8@008-AM1MPN1-003.mgdnok.nokia.com>
	 <20120118150015.GB18315@suse.de>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Wed, 18 Jan 2012 17:20:50 +0200
Message-ID: <1326900050.13624.19.camel@jaguar>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-18 at 07:00 -0800, Greg KH wrote:
> On Wed, Jan 18, 2012 at 02:47:47PM +0000, leonid.moiseichuk@nokia.com wrote:
> > > -----Original Message-----
> > > From: ext Greg KH [mailto:gregkh@suse.de]
> > > Sent: 18 January, 2012 16:09
> > ...
> > 
> > > > > +EXPORT_SYMBOL(si_swapinfo);
> > > 
> > > EXPORT_SYMBOL_GPL() perhaps?
> > 
> > I followed si_meminfo which is uses EXPORT_SYMBOL.
> 
> Ah, good point.

Yup, I think EXPORT_SYMBOL is appropriate here.

