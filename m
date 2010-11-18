Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760413Ab0KRU4x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 15:56:53 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35241
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760349Ab0KRU4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 15:56:52 -0500
Date: Thu, 18 Nov 2010 12:57:17 -0800 (PST)
Message-Id: <20101118.125717.52197531.davem@davemloft.net>
To: grant.likely@secretlab.ca
Cc: ddaney@caviumnetworks.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] phylib: Add support for Marvell 88E1149R devices.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101118204410.GB16908@angua.secretlab.ca>
References: <1290038071-13296-3-git-send-email-ddaney@caviumnetworks.com>
	<20101118.114616.258106719.davem@davemloft.net>
	<20101118204410.GB16908@angua.secretlab.ca>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 18 Nov 2010 13:44:10 -0700

> On Thu, Nov 18, 2010 at 11:46:16AM -0800, David Miller wrote:
>> From: David Daney <ddaney@caviumnetworks.com>
>> Date: Wed, 17 Nov 2010 15:54:31 -0800
>> 
>> > The 88E1149R is 10/100/1000 quad-gigabit Ethernet PHY.  The
>> > .config_aneg function can be shared with 88E1118, but it needs its own
>> > .config_init.
>> > 
>> > Signed-off-by: David Daney <ddaney@caviumnetworks.com>
>> 
>> Please resend this when you've respun patch #1 based upon the feedback
>> you've been given.
> 
> It looks to me that this patch has no dependencies on the first patch.
> ddaney; what say you?

It absolutely does, it references a function create by patch #1

In fact it's the whole _entire_ point of patch #1, to allow
patch #2 to be possible.  Did you even check?

Otherwise I would waste his time asking for a respin.
