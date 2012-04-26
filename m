Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756934Ab2DZOse (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 10:48:34 -0400
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:9411 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339Ab2DZOsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 10:48:33 -0400
Message-ID: <1335451710.2529.4.camel@lorien2>
Subject: Re: [PATCH  v2] leds: add new transient trigger for one shot timer
 activation
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: NeilBrown <neilb@suse.de>
Cc: shuahkhan@gmail.com, akpm@linux-foundation.org,
        Jonas Bonn <jonas@southpole.se>, LKML <linux-kernel@vger.kernel.org>,
        Richard Purdie <richard.purdie@linuxfoundation.org>
Date: Thu, 26 Apr 2012 08:48:30 -0600
In-Reply-To: <20120426160227.214fcb17@notabene.brown>
References: <1333310039.2879.4.camel@lorien2> <1334064283.10826.6.camel@ted>
	 <1334507752.2723.3.camel@lorien2> <1334894674.3051.18.camel@lorien2>
	 <1334983269.2435.90.camel@jerome.southpole.se>
	 <1335138687.2882.20.camel@lorien2> <20120423115610.2da4d4d7@notabene.brown>
	 <1335158999.5139.47.camel@jerome.southpole.se>
	 <20120423154546.415bd6c0@notabene.brown> <1335219745.2850.7.camel@lorien2>
	 <1335375758.5313.22.camel@lorien2> <20120426160227.214fcb17@notabene.brown>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-04-26 at 16:02 +1000, NeilBrown wrote:
> On Wed, 25 Apr 2012 11:42:38 -0600 Shuah Khan <shuahkhan@gmail.com> wrote:
> 
> > There was a suggestion to change units to seconds similar to "safe_delay_show" 
> > and "safe_delay_store" in drivers/md/md.c. safe_delay_show shows time in
> > seconds, however safe_delay_store still takes the value in msecs. This
> > sounded like an asymmetric interface.
> 
> I don't think you read the code properly.  "strict_strtoul_scaled" takes
> a number like "0.20" and scales it to an integer...
> (though your decision not to take that approach may still be justified).

My bad. Yes you are right. strict_strtoul_scaled() does do scaling. This
routine is currently defined in drivers/md/md.c. The right to do would
be to move this routine to where kstrtoul() is for general consumption.
Something I might take on as a separate task. :)

-- Shuah


