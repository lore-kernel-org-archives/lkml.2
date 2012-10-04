Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946580Ab2JDVcI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:32:08 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37526 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946476Ab2JDVbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:31:48 -0400
Date: Thu, 4 Oct 2012 22:31:43 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Roger Blofeld <blofeldus@yahoo.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Message-ID: <20121004213142.GH13292@decadent.org.uk>
References: <6a854f579a99b4fe2efaca1057e8ae22@local>
 <20121001225201.807308843@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121001225201.807308843@1wt.eu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [ 099/180] powerpc/ftrace: Fix assembly trampoline register
 usage
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 12:53:36AM +0200, Willy Tarreau wrote:
> 2.6.32-longterm review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: roger blofeld <blofeldus@yahoo.com>
> 
> commit fd5a42980e1cf327b7240adf5e7b51ea41c23437 upstream.
> 
> Just like the module loader, ftrace needs to be updated to use r12
> instead of r11 with newer gcc's.
> 
> Signed-off-by: Roger Blofeld <blofeldus@yahoo.com>
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> commit a8ed5765b5a8bf44a86284d80afd24f37a23e369 upstream.

This second commit hash refers to the version in th 3.0 stable branch
and should presumably be removed from the commit message for 2.6.32.y.

Ben.

> Signed-off-by: Willy Tarreau <w@1wt.eu>
[...]

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
