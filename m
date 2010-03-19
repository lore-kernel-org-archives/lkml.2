Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665Ab0CSP3L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 11:29:11 -0400
Received: from nat.scz.novell.com ([213.151.88.252]:42389 "EHLO dhcp35"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752105Ab0CSP3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 11:29:09 -0400
Date: Fri, 19 Mar 2010 16:29:04 +0100
From: Michal Hocko <mstsxfx@gmail.com>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: unable to handle kernel paging request on resume with
 2.6.33-00001-gbaac35c
Message-ID: <20100319152904.GB4090@tiehlicka.suse.cz>
References: <20100301175256.GA4034@tiehlicka.suse.cz>
 <201003121840.13938.maciej.rutecki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003121840.13938.maciej.rutecki@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 12, 2010 at 06:40:13PM +0100, Maciej Rutecki wrote:
> On poniedzia??ek, 1 marca 2010 o 18:52:57 Michal Hocko wrote:
> > Hi,
> > 
> > I have experienced the following kernel BUG on resume from suspend from
> > disk (the whole log from  hibarnation to suspend along with kernel
> > config are attached):
> > 
> 
> I created a Bugzilla entry at http://bugzilla.kernel.org/show_bug.cgi?id=15526
> for your bug report, please add your address to the CC list in there, thanks!

I haven't seen the same problem since I reported it but it seems that my
laptop is slowly dying (I had several random hangs with no crash) so I
guess that this is HW related.

> 
> -- 
> Maciej Rutecki
> http://www.maciek.unixy.pl

-- 
Michal Hocko
