Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236Ab1B1SAm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 13:00:42 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58657 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387Ab1B1SAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 13:00:41 -0500
Date: Mon, 28 Feb 2011 12:45:18 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Albert Cahalan <acahalan@gmail.com>
Cc: Hagen Paul Pfeifer <hagen@jauu.net>,
        Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mikael Abrahamsson <swmike@swm.pp.se>,
        linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Subject: Re: txqueuelen has wrong units; should be time
Message-ID: <20110228174517.GD2515@tuxdriver.com>
References: <AANLkTimd5GQwtUFP2fD_An=M8ajBD8DJpzxQJezv8fB8@mail.gmail.com>
 <alpine.DEB.1.10.1102270758580.11974@uplift.swm.pp.se>
 <1298793252.8726.45.camel@edumazet-laptop>
 <AANLkTinyE10wtM_xJsufT_3s3hvti7CN+9nyqScWa6SA@mail.gmail.com>
 <20110227125540.40754c5y78j9u2m8@hayate.sektori.org>
 <AANLkTimofhhH5omyk=HhkyaNG+MGqoac4rDf=dPuR7K-@mail.gmail.com>
 <cbb9e1113901f1a324359b6ed3f1a611@localhost>
 <AANLkTimh1xWU9V9phOKZZMgOWKOmDDSBYfofnnOjjRh=@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimh1xWU9V9phOKZZMgOWKOmDDSBYfofnnOjjRh=@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 28, 2011 at 11:37:45AM -0500, Albert Cahalan wrote:

> Keeping the timeout really low is important because it isn't
> OK to eat up all the latency tolerance in one hop. You have
> an end-to-end budget of 20 ms for usable GUI rubber banding.
> The budget for gaming is about 80 and for VoIP is about 150.

Oooh, numbers! :-)

Where can I find estimates on average hop counts for internet
connections?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
