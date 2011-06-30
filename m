Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751115Ab1F3RDf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 13:03:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33029 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750976Ab1F3RDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 13:03:31 -0400
Date: Thu, 30 Jun 2011 10:03:22 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Alexander Stein <alexander.stein@systec-electronic.com>
Cc: "David S. Miller" <davem@davemloft.net>, bridge@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: possible bridge regression in "bridge: implement
 [add/del]_slave ops"?
Message-ID: <20110630100322.21c7b28a@nehalam.ftrdhcpuser.net>
In-Reply-To: <201106301527.19539.alexander.stein@systec-electronic.com>
References: <201106301033.23997.alexander.stein@systec-electronic.com>
	<201106301527.19539.alexander.stein@systec-electronic.com>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jun 2011 15:27:19 +0200
Alexander Stein <alexander.stein@systec-electronic.com> wrote:

> On Thursday 30 June 2011 10:33:23 Alexander Stein wrote:
> > BTW: I noticed that in 2.6.39.2 independently from this patch revert this
> > bridge didn't show up RUNNING ifconfg. Is this intended? Another bridge I
> > have, which doesn't use (R)STP, is shown as RUNNING like before.
> 
> This change was caused by commit 1faa4356a3bd89ea11fb92752d897cff3a20ec0e 
> "bridge: control carrier based on ports online". It prevents the bridge from 
> actually receiving/sending packets. Reverting restores the old behavior.

It is really a bug in RSTP, I will fix it there.
