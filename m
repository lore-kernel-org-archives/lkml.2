Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557Ab2GSMJ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 08:09:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31751 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899Ab2GSMJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 08:09:56 -0400
Date: Thu, 19 Jul 2012 15:10:31 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        gleb@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: fix race with level interrupts
Message-ID: <20120719121031.GA9303@redhat.com>
References: <20120718215228.GA13905@redhat.com>
 <1342649774.2229.223.camel@bling.home>
 <20120718224459.GA14101@redhat.com>
 <1342653762.2229.236.camel@bling.home>
 <20120719091510.GC20120@redhat.com>
 <1342699591.3229.46.camel@ul30vt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342699591.3229.46.camel@ul30vt>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2012 at 06:06:31AM -0600, Alex Williamson wrote:
> On Thu, 2012-07-19 at 12:15 +0300, Michael S. Tsirkin wrote:
> > On Wed, Jul 18, 2012 at 05:22:42PM -0600, Alex Williamson wrote:
> > > I hate reviewing code
> > > > > where I have to differentiate 'l' vs '1'.
> > > > 
> > > > l is an illegal variable name?  Switch to a different font.
> > > 
> > > WTF
> > 
> > Really, you should use a font where these differ. I currently use
> > Monospace but there are many other good fonts.  If you don't bugs sneak
> > in.
> > 
> > int x = 11;
> > and
> > int x = 1l;
> > 
> > Should look very different.
> 
> Don't be an asshole, my dog could tell the difference between those
> side-by-side.  That's not what you posted.  I use monospace as well and
> find it offensive that you suggest someone change fonts to review your
> code.  Clearly, any time spent trying to identify a single character in
> isolation is not well spent.
> 

I apologize for offending you, this was not my intent.
I sent v2 to address your comments, thanks.

-- 
MST
