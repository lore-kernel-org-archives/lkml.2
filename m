Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679Ab1GOGyw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 02:54:52 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47120 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744Ab1GOGyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 02:54:51 -0400
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mcp23s08: remove unused work queue
References: <1310673568-30577-1-git-send-email-jacmet@sunsite.dk>
	<1310673568-30577-2-git-send-email-jacmet@sunsite.dk>
	<20110715025357.GY2927@ponder.secretlab.ca>
Date: Fri, 15 Jul 2011 08:54:43 +0200
In-Reply-To: <20110715025357.GY2927@ponder.secretlab.ca> (Grant Likely's
	message of "Thu, 14 Jul 2011 20:53:57 -0600")
Message-ID: <87ei1sav9o.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Grant" == Grant Likely <grant.likely@secretlab.ca> writes:

 Grant> On Thu, Jul 14, 2011 at 09:59:26PM +0200, Peter Korsgaard wrote:
 >> Never accessed anywhere.
 >> 
 >> Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>

 Grant> I've applied this, but I had to do it manually.  Please rebase the
 Grant> remaining two patches on linux-next.

Thanks, I will.

-- 
Bye, Peter Korsgaard
