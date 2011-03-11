Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025Ab1CKVAx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 16:00:53 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38652
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754283Ab1CKVAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 16:00:51 -0500
Date: Fri, 11 Mar 2011 13:01:28 -0800 (PST)
Message-Id: <20110311.130128.71121155.davem@davemloft.net>
To: bfields@fieldses.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110311204823.GB7906@fieldses.org>
References: <20110310.155556.48513201.davem@davemloft.net>
	<AANLkTik3AyFTNoytebmOOZ=JSFMkt0bw7au-CSncUHJu@mail.gmail.com>
	<20110311204823.GB7906@fieldses.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "J. Bruce Fields" <bfields@fieldses.org>
Date: Fri, 11 Mar 2011 15:48:23 -0500

> As with the above, it'd make the history a little more self-documenting.

Once there is even one single commit after the buggy one, this is
simply impossible since the hashes of subsequent commits depend upon
the precise contents of the original one.
