Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496Ab0INUko (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 16:40:44 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54757
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752113Ab0INUkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 16:40:43 -0400
Date: Tue, 14 Sep 2010 13:41:01 -0700 (PDT)
Message-Id: <20100914.134101.91345092.davem@davemloft.net>
To: dreibh@iem.uni-due.de
Cc: linux-kernel@vger.kernel.org, martin.becke@uni-due.de
Subject: Re: [PATCH] net: SCTP NULL-pointer dereference problem description
 and fix
From: David Miller <davem@davemloft.net>
In-Reply-To: <201009141901.13357.dreibh@iem.uni-due.de>
References: <201009141901.13357.dreibh@iem.uni-due.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please submit networking patches with netdev@vger.kernel.org on the
CC: list and also as this is an SCTP patch the CC: list should include
linux-sctp@vger.kernel.org and the SCTP maintainer as well.

Thanks.
