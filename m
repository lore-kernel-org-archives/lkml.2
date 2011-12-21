Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071Ab1LUVRT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 16:17:19 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:55522 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab1LUVRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 16:17:15 -0500
Date: Wed, 21 Dec 2011 16:16:07 -0500 (EST)
Message-Id: <20111221.161607.1331587831465613240.davem@davemloft.net>
To: tytso@mit.edu
Cc: johannes@sipsolutions.net, linux-kernel@vger.kernel.org,
        ilw@linux.intel.com, linux-wireless@vger.kernel.org
Subject: Re: REGRESSION: v3.2-rcX: iwlagn refuses to associate with my AP's
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111221211213.GB32561@thunk.org>
References: <20111213201752.GA5094@thunk.org>
	<20111214015959.GA6276@thunk.org>
	<20111221211213.GB32561@thunk.org>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 21 Dec 2011 13:16:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ted Ts'o" <tytso@mit.edu>
Date: Wed, 21 Dec 2011 16:12:13 -0500

> On Tue, Dec 13, 2011 at 08:59:59PM -0500, Ted Ts'o wrote:
>> On Tue, Dec 13, 2011 at 03:17:52PM -0500, Ted Ts'o wrote:
>> ... and the second problem I had with associating with EAP-TLS
>> encrypted SSID's was solved by Wey-Yi's patch: 
>> 
>> 	  iwlwifi: allow to switch to HT40 if not associated yet
>> 
>> ... found in the thread "iwlagn regression in v3.1.5"
>> 
>> So with these two patches applied, things are now stable for me.
> 
> It seems that fixes for these two issues haven't been pushed to Linus
> yet?  It would be nice if they could get pushed to mainline before 3.2
> ships, as opposed to being something that has to get fixed in the
> 3.2.X series....

It's in my queue to send to Linus.
