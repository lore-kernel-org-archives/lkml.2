Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306Ab2GSMGf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 08:06:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49556 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901Ab2GSMGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 08:06:32 -0400
Message-ID: <1342699591.3229.46.camel@ul30vt>
Subject: Re: [PATCH] kvm: fix race with level interrupts
From: Alex Williamson <alex.williamson@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        gleb@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 19 Jul 2012 06:06:31 -0600
In-Reply-To: <20120719091510.GC20120@redhat.com>
References: <20120718215228.GA13905@redhat.com>
	 <1342649774.2229.223.camel@bling.home> <20120718224459.GA14101@redhat.com>
	 <1342653762.2229.236.camel@bling.home> <20120719091510.GC20120@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-19 at 12:15 +0300, Michael S. Tsirkin wrote:
> On Wed, Jul 18, 2012 at 05:22:42PM -0600, Alex Williamson wrote:
> > I hate reviewing code
> > > > where I have to differentiate 'l' vs '1'.
> > > 
> > > l is an illegal variable name?  Switch to a different font.
> > 
> > WTF
> 
> Really, you should use a font where these differ. I currently use
> Monospace but there are many other good fonts.  If you don't bugs sneak
> in.
> 
> int x = 11;
> and
> int x = 1l;
> 
> Should look very different.

Don't be an asshole, my dog could tell the difference between those
side-by-side.  That's not what you posted.  I use monospace as well and
find it offensive that you suggest someone change fonts to review your
code.  Clearly, any time spent trying to identify a single character in
isolation is not well spent.



