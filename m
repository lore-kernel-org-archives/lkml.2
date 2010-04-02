Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966Ab0DBRhq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 13:37:46 -0400
Received: from mail.atheros.com ([12.36.123.2]:11926 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755369Ab0DBRhj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 13:37:39 -0400
Date: Fri, 2 Apr 2010 10:37:37 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Greg KH <greg@kroah.com>
CC: Luis Rodriguez <Luis.Rodriguez@atheros.com>, Greg KH <gregkh@suse.de>,
       Peter Stuge <peter@stuge.se>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       Kristoffer Ericson <kristoffer.ericson@gmail.com>,
       "stable-review@kernel.org" <stable-review@kernel.org>,
       "Justin P. Mattock" <justinmattock@gmail.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "stable@kernel.org" <stable@kernel.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: Re: [stable] [Stable-review] [patch 070/123] ath9k: re-enable ps
 by default for new single chip families
Message-ID: <20100402173737.GB2220@tux>
References: <20100313001618.GA9811@kroah.com>
 <20100313001511.285517122@kvm.kroah.org>
 <43e72e891003151804s617659f8o6dcbf0b5ab63cb5d@mail.gmail.com>
 <20100319000438.GV5454@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20100319000438.GV5454@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 18, 2010 at 05:04:38PM -0700, Greg KH wrote:
> On Mon, Mar 15, 2010 at 06:04:15PM -0700, Luis R. Rodriguez wrote:
> > On Fri, Mar 12, 2010 at 5:12 PM, Greg KH <gregkh@suse.de> wrote:
> > > 2.6.33-stable review patch.  If anyone has any objections, please let me know.
> > 
> > This was intended for 2.6.32 as well. Thanks
> 
> Great, but it didn't apply there, so I didn't try to force it :)
> 
> Care to provide a backport?

Sorry, been, busy, I've put together a page to keep track of these sort of things:

http://wireless.kernel.org/en/developers/stable-pending

  Luis
