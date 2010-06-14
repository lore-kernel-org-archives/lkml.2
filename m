Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823Ab0FNQYl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 12:24:41 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:39659 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826Ab0FNQYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 12:24:40 -0400
Date: Tue, 15 Jun 2010 01:24:38 +0900
From: Norbert Preining <preining@logic.at>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: iwlagn completely unusable with some AP since 2.6.31
Message-ID: <20100614162438.GB31239@gamma.logic.tuwien.ac.at>
References: <20100614160910.GA10738@gandalf.dynalias.org> <20100614162048.GA28894@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100614162048.GA28894@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mo, 14 Jun 2010, Christoph Hellwig wrote:
> I see the same issue, and I even tried the git bisect, but due to
> various issues in early boot / ACPI code in that merge window it's

Me, too, but as you said, hard to finish, it is getting weird when we
come down to the merge window.

Is there a way to restrict git bisect to consider *only* changes in 
a specific sub-directory (directories) ? That would help.

> impossible to finish it.  The ugly workaround for me is to always keep
> a ping running in the background, which keeps it from dropping the

I had the feeling that this helped a bit, but didn't explore it
in an organized way. Thanks for the tip.

Let's hope for the best

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
`Er, hey Earthman...'
`Arthur,' said Arthur.
`Yeah, could you just sort of keep this robot with you and
guard this end of the passageway. OK?'
What from? You just said there's no
one here.'
`Yeah, well, just for safety, OK?' said Zaphod.
`Whose? Yours or mine?'
                 --- Arthur drawing the short straw on Magrathea.
                 --- Douglas Adams, The Hitchhikers Guide to the Galaxy
