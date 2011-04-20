Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751734Ab1DTSQr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 14:16:47 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:6680 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750695Ab1DTSQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 14:16:46 -0400
From: Dmitry Torokhov <dtor@vmware.com>
Organization: VMware, Inc.
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: [Stable-review] [24/28] USB: xhci - fix unsafe macro definitions
Date: Wed, 20 Apr 2011 11:16:44 -0700
User-Agent: KMail/1.13.6 (Linux/2.6.35.12-88.fc14.x86_64; KDE/4.6.1; x86_64; ; )
Cc: Ben Hutchings <ben@decadent.org.uk>, Willy Tarreau <w@1wt.eu>,
        Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        stable@kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable-review@kernel.org,
        alan@lxorguk.ukuu.org.uk
References: <20110419204119.285492847@clark.kroah.org> <1303302875.3464.96.camel@localhost> <20110420173252.GA5343@xanatos>
In-Reply-To: <20110420173252.GA5343@xanatos>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104201116.45310.dtor@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 20, 2011 10:32:52 AM Sarah Sharp wrote:
> On Wed, Apr 20, 2011 at 01:34:35PM +0100, Ben Hutchings wrote:
> > On Wed, 2011-04-20 at 07:39 +0200, Willy Tarreau wrote:
> > > On Wed, Apr 20, 2011 at 03:02:04AM +0100, Ben Hutchings wrote:
> > > > On Tue, 2011-04-19 at 13:31 -0700, Greg KH wrote:
> > > > > 2.6.32-longterm review patch.  If anyone has any objections,
> > > > > please let us know.
> > > > > 
> > > > > ------------------
> > > > > 
> > > > > From: Dmitry Torokhov <dtor@vmware.com>
> > > > > 
> > > > > commit 5a6c2f3ff039154872ce597952f8b8900ea0d732 upstream.
> > > > > 
> > > > > Macro arguments used in expressions need to be enclosed in
> > > > > parenthesis to avoid unpleasant surprises.
> > > > 
> > > > Do you know of any specific uses of these macros where the missing
> > > > parentheses caused 'unpleasant surprises'?
> > > 
> > > In my opinion, this type of fix should be backported even if the
> > > current code does not appear to be at risk, otherwise a later fix
> > > in the kernel could cause a serious regression when backported to
> > > -stable. For instance,
> > 
> > > if we later have to backport this patch (cut'n'pasted) :
> > [...]
> > 
> > I agree, but would like to know whether there is an immediate effect.
> 
> No immediate breakage, AFAIK.  Dmitry found the issue by inspection.

Right, mainline (and next) appear to be safe at the moment.

Thanks,
Dmitry
