Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821Ab1DLWav (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 18:30:51 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52030
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753953Ab1DLWau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 18:30:50 -0400
Date: Tue, 12 Apr 2011 15:30:14 -0700 (PDT)
Message-Id: <20110412.153014.242140030.davem@davemloft.net>
To: davej@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: fix locking unbalance in irda_sendmsg
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110412221254.GA23906@redhat.com>
References: <20110412221254.GA23906@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Jones <davej@redhat.com>
Date: Tue, 12 Apr 2011 18:12:55 -0400

> 5b40964eadea40509d353318d2c82e8b7bf5e8a5 introduced a path where
> we have a locking unbalance.  If we pass invalid flags, we unlock
> a socket we never locked, resulting in this...
 ...
> Signed-off-by: Dave Jones <davej@redhat.com>

Applied and queued up for -stable, thanks Dave.
