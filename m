Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760291Ab0JIQXc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 12:23:32 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47529
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756388Ab0JIQXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 12:23:31 -0400
Date: Sat, 09 Oct 2010 09:23:53 -0700 (PDT)
Message-Id: <20101009.092353.57476425.davem@davemloft.net>
To: mcarlson@broadcom.com
Cc: nikai@nikai.net, mchan@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/tg3: simplify conditional
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101008174312.GA3562@mcarlson.broadcom.com>
References: <20101008112927.0ca949cf@absol.kitzblitz>
	<20101008174312.GA3562@mcarlson.broadcom.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Matt Carlson" <mcarlson@broadcom.com>
Date: Fri, 8 Oct 2010 10:43:12 -0700

> On Fri, Oct 08, 2010 at 02:29:27AM -0700, Nicolas Kaiser wrote:
>> Simplify: ((a && !b) || (!a && b)) => (a != b)
>> 
>> Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
 ...
> Looks good to me.

Applied.

Matt, you can give an "Acked-by: " tag to indicate your approval
of a patch in the future :-)

Thanks.
