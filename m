Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347Ab0FDWXe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 18:23:34 -0400
Received: from mail.vyatta.com ([76.74.103.46]:46225 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757140Ab0FDWXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 18:23:33 -0400
Date: Fri, 4 Jun 2010 15:23:24 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: netdev@vger.kernel.org, "H. Peter Anvin" <hpa@kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>, linux-kernel@vger.kernel.org
Subject: Re: Ethernet drivers wiki page
Message-ID: <20100604152324.1fa28f2f@nehalam>
In-Reply-To: <AANLkTik1isTBolg4IDchOlmKqXOLjQoobZrJ-9bb8ZL5@mail.gmail.com>
References: <AANLkTinSjJsqNvEhJZIE6cJxEkBtg-DO2dqZWMczUy2i@mail.gmail.com>
	<AANLkTik1isTBolg4IDchOlmKqXOLjQoobZrJ-9bb8ZL5@mail.gmail.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Jun 2010 15:04:17 -0700
"Luis R. Rodriguez" <mcgrof@gmail.com> wrote:

> On Fri, Jun 4, 2010 at 2:52 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> > Where can I start adding documentation for our Ethernet drivers
> > upstream? I was hoping for a wiki but I don't think we have a netdev
> > one yet. Shall we create one or piggy back on something else? I'm
> > reviewing:
> >
> > https://wiki.kernel.org/
> >
> > FWIW, I want to see something like this:
> >
> > http://wireless.kernel.org/en/users/Drivers
> >
> > But for ethernet.
> 
> Since I've stuffed a few ethernet drivers on compat-wireless I might
> as well start carrying more. So now we'd have 802.11, Bluetooth and
> Ethernet all backported using the same framework, automatically, down
> to at least the oldest stable kernel supported listed on kernel.org
> and using all a generic compat module.
> 
> I want to document all this crap.

Why not Documentation/networking in kernel source? There is already
documentation there though much of it is out of date.
This has the advantage of having change log and matching kernel version.
