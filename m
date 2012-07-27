Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226Ab2G0C6Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 22:58:16 -0400
Received: from matrix.voodoobox.net ([75.127.97.206]:44590 "EHLO
	matrix.voodoobox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774Ab2G0C6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 22:58:14 -0400
Message-ID: <1343355430.29938.6.camel@obelisk.thedillows.org>
Subject: Re: RAID extremely slow
From: David Dillow <dave@thedillows.org>
To: Kevin Ross <kevin@familyross.net>
Cc: Phil Turmel <philip@turmel.org>, linux-kernel@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>
Date: Thu, 26 Jul 2012 22:17:10 -0400
In-Reply-To: <1343355303.29938.5.camel@obelisk.thedillows.org>
References: <501078B2.8070707@familyross.net> <501096C3.5060700@turmel.org>
	 <5010A386.4080209@familyross.net>
	 <1343355303.29938.5.camel@obelisk.thedillows.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-26 at 22:15 -0400, David Dillow wrote:
> If you can, upgrade to the latest 3.4 stable kernel (3.4.6 right now).
> As far as I can see, the latest 3.2 stable does not contain the delayed
> stripe fix.

And I was looking at the wrong version; 3.2.24 does indeed have the fix.

