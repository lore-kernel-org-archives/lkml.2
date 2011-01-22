Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490Ab1AVUu7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 15:50:59 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:50986 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab1AVUu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 15:50:58 -0500
Date: Sat, 22 Jan 2011 15:50:45 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Dima Zavin <dmitriyz@google.com>, Pekka Enberg <penberg@kernel.org>,
        Daniel Walker <dwalker@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Joe Perches <joe@perches.com>, davidb@codeaurora.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/7] Nexus One Support
Message-ID: <20110122205045.GB8666@infradead.org>
References: <20110121100441.06a94482@jbarnes-desktop>
 <1295633882.19880.31.camel@m0nster>
 <AANLkTi=L+MW5-KLP_TKSxhstD8JEtBW=RKci5wSbZsd6@mail.gmail.com>
 <1295642995.19880.42.camel@m0nster>
 <1295643762.25868.31.camel@Joe-Laptop>
 <1295645098.22882.1.camel@m0nster>
 <AANLkTi=mvdfpCPefGeDr+eGxpSUr3is5jgugHtgB-m1w@mail.gmail.com>
 <20110122122018.GC5194@n2100.arm.linux.org.uk>
 <AANLkTinH47x9S8m3yKt3MarCDudB0Sdh3gFWb_MHGrRA@mail.gmail.com>
 <20110122184909.GB11960@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110122184909.GB11960@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 22, 2011 at 06:49:09PM +0000, Russell King - ARM Linux wrote:
> http://android.git.kernel.org/?p=kernel/msm.git;a=commit;h=37431502c4

> Maybe you could illustrate how to take that particular commit, which
> Daniel apparantly based his 3/7 patch on, and identify who Daniel should
> and should not give credit to using *just* the text in that commit and
> no other information.

I'd add a:

"Based a on shitty codedump from a secrit Google repository, credited to
 Dima Zavin <dmitriyz@google.com>."
 
at the end of the commit line and Cc Dima to see if there's any
interested from his side to sort this out.  But maybe that's just my
attitude, and a less colourful language would also do it.

