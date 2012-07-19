Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab2GSJOj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 05:14:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58439 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753941Ab2GSJOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 05:14:36 -0400
Date: Thu, 19 Jul 2012 12:15:11 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        gleb@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: fix race with level interrupts
Message-ID: <20120719091510.GC20120@redhat.com>
References: <20120718215228.GA13905@redhat.com>
 <1342649774.2229.223.camel@bling.home>
 <20120718224459.GA14101@redhat.com>
 <1342653762.2229.236.camel@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342653762.2229.236.camel@bling.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 05:22:42PM -0600, Alex Williamson wrote:
> I hate reviewing code
> > > where I have to differentiate 'l' vs '1'.
> > 
> > l is an illegal variable name?  Switch to a different font.
> 
> WTF

Really, you should use a font where these differ. I currently use
Monospace but there are many other good fonts.  If you don't bugs sneak
in.

int x = 11;
and
int x = 1l;

Should look very different.

-- 
MST
