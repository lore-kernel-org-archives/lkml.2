Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781Ab1LVUjx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 15:39:53 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:53777 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753019Ab1LVUjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 15:39:52 -0500
X-Sasl-enc: VFBvFcD0vz2gwFfaIrkJ8yCxkOqPDn2EdeAKayH7bKCJ 1324586391
Date: Thu, 22 Dec 2011 12:37:56 -0800
From: Greg KH <greg@kroah.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        oprofile-list <oprofile-list@lists.sourceforge.net>,
        John Lumby <johnlumby@hotmail.com>,
        Maynard Johnson <maynardj@us.ibm.com>
Subject: Re: [13/16] [PATCH 2/3] oprofile, x86: Fix nmi-unsafe callgraph
 support
Message-ID: <20111222203756.GA28092@kroah.com>
References: <20111216205049.GA28030@kroah.com>
 <20111216205043.465306786@clark.kroah.org>
 <20111218160401.GA16765@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111218160401.GA16765@erda.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 18, 2011 at 05:04:01PM +0100, Robert Richter wrote:
> On 16.12.11 12:49:46, Greg KH wrote:
> > 2.6.32-longterm review patch.  If anyone has any objections, please let me know.
> 
> Looks like the [PATCH ...] should be stripped in the subject line.
> 
> Same with
> 
>  [14/16] [PATCH 3/3] oprofile, x86: Fix crash when unloading module (timer mode)

oops, you are right, oh well, I messed that one up...

greg k-h
