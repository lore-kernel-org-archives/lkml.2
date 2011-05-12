Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757604Ab1ELSgW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 14:36:22 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:44718 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752293Ab1ELSgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 14:36:20 -0400
Subject: Re: [PATCH 3/3] mm: slub: Default slub_max_order to 0
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>, Dave Jones <davej@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Colin King <colin.king@canonical.com>,
        Raghavendra D Prabhu <raghu.prabhu13@gmail.com>,
        Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>
In-Reply-To: <BANLkTimDsJDht76Vm7auNqT2gncjpEKZQw@mail.gmail.com>
References: <1305127773-10570-1-git-send-email-mgorman@suse.de>
	 <1305127773-10570-4-git-send-email-mgorman@suse.de>
	 <alpine.DEB.2.00.1105120942050.24560@router.home>
	 <1305213359.2575.46.camel@mulgrave.site>
	 <alpine.DEB.2.00.1105121024350.26013@router.home>
	 <1305214993.2575.50.camel@mulgrave.site> <20110512154649.GB4559@redhat.com>
	 <1305216023.2575.54.camel@mulgrave.site>
	 <alpine.DEB.2.00.1105121121120.26013@router.home>
	 <1305217843.2575.57.camel@mulgrave.site>
	 <BANLkTi=MD+voG1i7uDyueV22_daGHPRdqw@mail.gmail.com>
	 <BANLkTimDsJDht76Vm7auNqT2gncjpEKZQw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 May 2011 13:36:15 -0500
Message-ID: <1305225375.2575.65.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-12 at 20:11 +0300, Pekka Enberg wrote:
> On Thu, May 12, 2011 at 8:06 PM, Pekka Enberg <penberg@kernel.org> wrote:
> > On Thu, May 12, 2011 at 7:30 PM, James Bottomley
> > <James.Bottomley@hansenpartnership.com> wrote:
> >> So suggest an alternative root cause and a test to expose it.
> >
> > Is your .config available somewhere, btw?
> 
> If it's this:
> 
> http://pkgs.fedoraproject.org/gitweb/?p=kernel.git;a=blob_plain;f=config-x86_64-generic;hb=HEAD
> 
> I'd love to see what happens if you disable
> 
> CONFIG_TRANSPARENT_HUGEPAGE=y
> 
> because that's going to reduce high order allocations as well, no?

So yes, it's a default FC15 config.

Disabling THP was initially tried a long time ago and didn't make a
difference (it was originally suggested by Chris Mason).

James


