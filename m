Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761431Ab0J1Szk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 14:55:40 -0400
Received: from thunk.org ([69.25.196.29]:37694 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761407Ab0J1Szg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 14:55:36 -0400
Date: Thu, 28 Oct 2010 14:55:31 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: sedat.dilek@gmail.com
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
        sfr@canb.auug.org.au, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [next-20101038] Call trace in ext4
Message-ID: <20101028185531.GE6814@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, sedat.dilek@gmail.com,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
	sfr@canb.auug.org.au, Arnd Bergmann <arnd@arndb.de>
References: <AANLkTi=E_uMj_ndGU86DCjX4aDwjHqg3dkwxjQRSJtq6@mail.gmail.com>
 <20101028175221.GA1578@arch.trippelsdorf.de>
 <AANLkTikOqeT8OznyMvL7XaWS06kh7ZZ+SJLyMfOc32P4@mail.gmail.com>
 <AANLkTi=O1a3ZWg500OgPPLDxQeoEUsRdqGwzcgNmc8RD@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=O1a3ZWg500OgPPLDxQeoEUsRdqGwzcgNmc8RD@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 28, 2010 at 08:34:19PM +0200, Sedat Dilek wrote:
> 
> One minute after I sent the mail, I ran into the error.
> Now, I could start my IRC-client for a while... till crash.

Yeah, the patchesin ext4/next are just things to fix compiling without
CONFIG_BLOCK or CONFIG_EXT4_FS_XATTR.  It doesn't make any code
changes at all.

					- Ted
