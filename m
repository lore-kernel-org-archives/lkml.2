Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760860Ab0J1SB3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 14:01:29 -0400
Received: from thunk.org ([69.25.196.29]:44140 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753828Ab0J1SBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 14:01:22 -0400
Date: Thu, 28 Oct 2010 14:01:18 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: sedat.dilek@gmail.com, LKML <linux-kernel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, sfr@canb.auug.org.au,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [next-20101038] Call trace in ext4
Message-ID: <20101028180118.GC6814@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Markus Trippelsdorf <markus@trippelsdorf.de>, sedat.dilek@gmail.com,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
	sfr@canb.auug.org.au, Arnd Bergmann <arnd@arndb.de>
References: <AANLkTi=E_uMj_ndGU86DCjX4aDwjHqg3dkwxjQRSJtq6@mail.gmail.com>
 <20101028175221.GA1578@arch.trippelsdorf.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101028175221.GA1578@arch.trippelsdorf.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 28, 2010 at 07:52:21PM +0200, Markus Trippelsdorf wrote:
> 
> The same BUG (inode.c:2721) happend here today running latest vanilla
> git. There is nothing in my logs unfortunately, but I shot a photo of
> the trace (see attachment).

I see, it's the page_buffers() call which is triggering.  Looking into
it...

							- Ted
