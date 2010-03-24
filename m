Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455Ab0CXNjn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 09:39:43 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60592 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755027Ab0CXNjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 09:39:42 -0400
Date: Wed, 24 Mar 2010 14:39:39 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       apw@canonical.com
Subject: Re: [PATCH] checkpatch: Add check for too short Kconfig descriptions
Message-ID: <20100324133939.GF20695@one.firstfloor.org>
References: <20100320023216.GA917@basil.fritz.box> <4BA4CE32.1020207@imap.cc> <20100320140710.GS20695@one.firstfloor.org> <4BA504DD.2060107@imap.cc> <20100320180336.GT20695@one.firstfloor.org> <4BAA0598.9000906@imap.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BAA0598.9000906@imap.cc>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> - -+			WARN("please write a paragraph that describes the config symbol fully\n" . $herecurr) if ($length < 4);
> ++			WARN("Less than four lines of help text -- consider adding more detail\n" . $herecurr) if ($length < 4);

I don't want to give the number, because that just tempts people
to "game" the rule. Ideally they should just use as many lines
as needed, not just four.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
