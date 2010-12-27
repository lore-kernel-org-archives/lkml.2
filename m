Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279Ab0L0ESA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Dec 2010 23:18:00 -0500
Received: from atl.turmel.org ([74.117.157.138]:56476 "EHLO atl.turmel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752703Ab0L0ER6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Dec 2010 23:17:58 -0500
Message-ID: <4D181373.3070107@turmel.org>
Date: Sun, 26 Dec 2010 23:17:55 -0500
From: Phil Turmel <philip@turmel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101212 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Marc Haber <mh+linux-kernel@zugschlus.de>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: NetXen NX3031 failing test, reporting link down, not working
References: <20101206171727.GA30695@torres.zugschlus.de> <20101225163632.GA27786@torres.zugschlus.de>
In-Reply-To: <20101225163632.GA27786@torres.zugschlus.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marc,

On 12/25/2010 11:36 AM, Marc Haber wrote:
> On Mon, Dec 06, 2010 at 06:17:27PM +0100, Marc Haber wrote:
>> I have HP DL 120 G6 with two Quad-GE Cards based on NetXen NX3031 (rev
>> 42) [4040:0100]. The boxes are running with a grml daily image with
>> kernel 2.6.36.1 for the time being, and the NetXens are giving me a
>> hard time.
> 
> it's a pity that nobody cared to even point me into the right
> direction. I am not aware of having done anything wrong.

Poor signal-to-noise ratio on lkml itself, so don't take it personally.  The net folk don't listen too closely, but akpm usually tosses these over the wall to 'em.  He seems to have missed this one, so I've added the most important CC.

> Anyway, the issue could be solved by updating the on-card flashed
> firmware from 4.0.530 to 4.0.539. With this firmware, everything seems
> to be fine.
> 
> Maybe the Linux driver should be adapted to not fail silently if it
> doesn't like the on-card firmware but instead log an error message so
> that people know they need to update their firmware.

I'm just a lurker, tester, and occasional bug reporter, so I can't speak to this.

Phil
