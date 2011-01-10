Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab1AJA0b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 19:26:31 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54565
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751564Ab1AJA02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 19:26:28 -0500
Date: Sun, 09 Jan 2011 16:27:00 -0800 (PST)
Message-Id: <20110109.162700.52191043.davem@davemloft.net>
To: randy.dunlap@oracle.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 4/6] net/sock.h: make some fields private to fix
 kernel-doc warning(s)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110108193921.e03ca09e.randy.dunlap@oracle.com>
References: <20110108193921.e03ca09e.randy.dunlap@oracle.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Sat, 8 Jan 2011 19:39:21 -0800

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix new kernel-doc notation warning in sock.h by annotating skc_dontcopy_*
> as private fields.
> 
> Warning(include/net/sock.h:163): No description found for parameter 'skc_dontcopy_end[0]'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Applied.
