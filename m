Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759364Ab2JYK2A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 06:28:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36436 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759295Ab2JYK16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 06:27:58 -0400
Date: Thu, 25 Oct 2012 11:20:28 +0100
From: Mel Gorman <mgorman@suse.de>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: MMTests 0.06
Message-ID: <20121025102028.GB2558@suse.de>
References: <20121012145114.GZ29125@suse.de>
 <CALF0-+UBq8kgC-uUkuk_akoyBgvkytgn0v+2uBTDLZcFCPeHrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <CALF0-+UBq8kgC-uUkuk_akoyBgvkytgn0v+2uBTDLZcFCPeHrQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 05:14:31PM -0300, Ezequiel Garcia wrote:
> > The stats reporting still needs work because while some tests know how
> > to make a better estimate of mean by filtering outliers it is not being
> > handled consistently and the methodology needs work. I know filtering
> > statistics like this is a major flaw in the methodology but the decision
> > was made in this case in the interest of the benchmarks with unstable
> > results completing in a reasonable time.
> >
> 
> FWIW, I found a minor problem with sudo and yum incantation when trying this.
> 
> I'm attaching a patch.
> 

Thanks very much. I've picked it up and it'll be in MMTests 0.07.

-- 
Mel Gorman
SUSE Labs
