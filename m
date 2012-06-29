Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272Ab2F2XMo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 19:12:44 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:43211 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789Ab2F2XMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 19:12:43 -0400
Date: Sat, 30 Jun 2012 00:12:37 +0100
From: Vincent Sanders <vincent.sanders@collabora.co.uk>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: AF_BUS socket address family
Message-ID: <20120629231236.GA28593@mail.collabora.co.uk>
References: <1340988354-26981-1-git-send-email-vincent.sanders@collabora.co.uk>
 <20120629.153656.1141845894730637434.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120629.153656.1141845894730637434.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 29, 2012 at 03:36:56PM -0700, David Miller wrote:
> 
> There is no extensive text describing why using IPv4 for this cannot
> be done.  I can almost bet that nobody really, honestly, tried.
> 

I can assure you that the team has tried no fewer than six differing
approaches, including using IP and attempting to bend several of the
existing address families.

> Basically this means all of our feedback from the last time we had
> discussions on kernel IPC for DBUS are being completely ignored.

Absolutely not, we listened hard and did extensive research, please do
not ascribe thoughtlessness to our actions. Certainly I would not
presume to waste your time and present something which has not been
thoroughly considered.

I had hoped you would have at least read the opening list where I
outlined the underlying features which explain why none of the
existing IPC match the requirements.

Firstly it is intended is an interprocess mechanism and not to rely on
a configured IP system, indeed one of its primary usages is to
provide mechanism for various tools to set up IP networking.

Leaving that aside the requirements for multicast, strict ordering, fd
passing and credential passing are simply not available in any other
single transport. It was made plain to us that AF_UNIX would not be
expanded to encompass multicast so we are left with adding AF_BUS.

If we are wrong I hope you will explain to me how we can achieve fd and
credential passing to multicast groups within existing protocols.

> 
> Therefore, I will completely ignore this patch submission.
> 

I do hope you will reconsider, or at least educate us appropriately. 
I understand you are a busy maintainer and appreciate your time in this matter.

Best regards
--
Vincent Sanders <vincent.sanders@collabora.co.uk>
