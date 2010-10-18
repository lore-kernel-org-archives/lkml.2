Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227Ab0JRPHu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 11:07:50 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40742 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207Ab0JRPHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 11:07:49 -0400
Date: Mon, 18 Oct 2010 16:07:37 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 04/22] arm: introduce little endian bitops
Message-ID: <20101018150737.GI12449@n2100.arm.linux.org.uk>
References: <1287135981-17604-1-git-send-email-akinobu.mita@gmail.com> <AANLkTi=1w9uV81CagrE53xEYkMaFh_3cM_+ybctT2ng4@mail.gmail.com> <20101018135616.GB12449@n2100.arm.linux.org.uk> <201010181645.13349.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201010181645.13349.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 04:45:12PM +0200, Arnd Bergmann wrote:
> Note that patches 20 and 22 of the series completely eliminate the
> the minix and ext2 definitions, putting them into architecture independent
> code in those two file systems where they belong.

Good.

> Adding the new definitions in patch 4 is just a logical step before removing
> the old definitions in the later patches while maintaining bisectability.

In which case I don't have a problem with the series.

> > What I'm trying to say is please don't make the existing mess of bitops
> > any worse than it currently is.
> 
> The series currently adds 20 lines to the arm code (could be reduced to
> 6 lines), but removes 26 lines which are essentially architecture
> independent and shouldn't be there to start with. I'd call that the
> opposite of making the mess worse.

Right - if I could've seen the rest of the series, then maybe I'd have
known that.  However, I seemed to have silently dropped off linux-arch
back in April and only just noticed, which means I've missed rather a
lot...
