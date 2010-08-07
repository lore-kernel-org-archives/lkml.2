Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762068Ab0HGL1A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 07:27:00 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:38651 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755617Ab0HGL07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 07:26:59 -0400
Date: Sat, 7 Aug 2010 13:26:56 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
        Greg KH <gregkh@suse.de>, akpm@linux-foundation.org
Subject: Re: [git pull] PCMCIA updates for 2.6.36
Message-ID: <20100807112656.GA17845@isilmar-3.linta.de>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
	Greg KH <gregkh@suse.de>, akpm@linux-foundation.org
References: <20100805220511.GA7040@comet.dominikbrodowski.net> <AANLkTin1x7P-4p2grwd=0fYoCB53uDkxgOETzXqk12X1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin1x7P-4p2grwd=0fYoCB53uDkxgOETzXqk12X1@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 06, 2010 at 12:28:31PM -0700, Linus Torvalds wrote:
> On Thu, Aug 5, 2010 at 3:05 PM, Dominik Brodowski
> <linux@dominikbrodowski.net> wrote:
> >
> > Please pull from that location. The diffstat and list of changes is below,
> > the individual diffs are sent (at least) to the linux-pcmcia list.
> 
> Hmm. You hadn't done proper removal of dev_info_t from the staging
> drivers. I tried to fix it up by hand, but quite frankly, I may well
> have messed something up. Please do check the result.

Looks good, thanks!

	Dominik
