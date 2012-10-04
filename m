Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946584Ab2JDVce (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:32:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37539 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946448Ab2JDVcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:32:31 -0400
Date: Thu, 4 Oct 2012 22:32:29 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tiejun Chen <tiejun.chen@windriver.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Message-ID: <20121004213229.GI13292@decadent.org.uk>
References: <6a854f579a99b4fe2efaca1057e8ae22@local>
 <20121001225201.843348475@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121001225201.843348475@1wt.eu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [ 100/180] powerpc: Add "memory" attribute for mfmsr()
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 12:53:37AM +0200, Willy Tarreau wrote:
> 2.6.32-longterm review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Tiejun Chen <tiejun.chen@windriver.com>
> 
> commit b416c9a10baae6a177b4f9ee858b8d309542fbef upstream.
> 
> Add "memory" attribute in inline assembly language as a compiler
> barrier to make sure 4.6.x GCC don't reorder mfmsr().
> 
> Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> commit 93487ce8d6edc7c550b1449770df5e44715f520f upstream.
[...]

Another 3.0 stable reference.

Ben.

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
