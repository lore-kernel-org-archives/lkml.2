Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825Ab1BCAZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 19:25:26 -0500
Received: from one.firstfloor.org ([213.235.205.2]:42324 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755743Ab1BCAZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 19:25:14 -0500
Date: Thu, 3 Feb 2011 01:25:13 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Andi Kleen <andi@firstfloor.org>, johannes@sipsolutions.net,
        linville@tuxdriver.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] [34/139] mac80211: Fix BUG in pskb_expand_head when transmitting shared skbs
Message-ID: <20110203002513.GL15569@one.firstfloor.org>
References: <20110201443.618138584@firstfloor.org> <20110202004349.64A543E09BD@tassilo.jf.intel.com> <AANLkTim4df7n9gky1sTgqchi+8KrrxV7JEf3mVq8O3f7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTim4df7n9gky1sTgqchi+8KrrxV7JEf3mVq8O3f7@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 02, 2011 at 11:53:44AM +0100, Helmut Schaa wrote:
> On Wed, Feb 2, 2011 at 1:43 AM, Andi Kleen <andi@firstfloor.org> wrote:
> > 2.6.35-longterm review patch.  If anyone has any objections, please let me know.
> 
> There has been a followup patch to this one [1]. That should be
> considered as well.

Added thanks.
-Andi
