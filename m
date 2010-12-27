Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993Ab0L0VdW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 16:33:22 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41314 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab0L0VdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 16:33:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rKcD8g9rRiMtNVaPjZO882BHkBjzX0hMsSeSOIAPCHJsvGGHBtZ9U5WY8PsfKxE0kK
         c/dGb7j1x6Or+LAoAYvNoRRFefnFSHPRHSuf8HqlWZEOhoeaRES6r+4VVVqSfdNyTYMR
         0QzibsM2b/ScHjXbKgEelLiroMEDlfDQR+cNg=
Date: Mon, 27 Dec 2010 23:33:14 +0200
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        David Woodhouse <David.Woodhouse@intel.com>, Greg KH <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH, Bugfix] RAMOOPS: Don't overflow over non-allocated
	regions
Message-ID: <20101227213314.GA30153@laptop>
References: <20101225095709.GA1345@laptop> <4D15D347.6050500@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D15D347.6050500@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 25, 2010 at 12:19:35PM +0100, Marco Stornelli wrote:
> Il 25/12/2010 10:57, Ahmed S. Darwish ha scritto:
> > 
> > Current code mis-calculates the ramoops header size, leading to an
> > overflow over the next record at best, or over a non-allocated region
> > at worst. Fix that calculation.
> > 
> > Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
> > --
> 
> Acked-by: Marco Stornelli <marco.stornelli@gmail.com>
>

Someone to push this to Linus before -rc8? Andrew?

--
Darwish
http://darwish.07.googlepages.com
