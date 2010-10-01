Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885Ab0JAAu3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 20:50:29 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42381
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753397Ab0JAAu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 20:50:26 -0400
Date: Thu, 30 Sep 2010 17:50:46 -0700 (PDT)
Message-Id: <20100930.175046.186311357.davem@davemloft.net>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, eric.dumazet@gmail.com,
        andy.grover@oracle.com
Subject: Re: [12/68] rds: fix a leak of kernel memory
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100924163345.068328091@clark.site>
References: <20100924163357.GA15741@kroah.com>
	<20100924163345.068328091@clark.site>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@suse.de>
Date: Fri, 24 Sep 2010 09:31:36 -0700

> 2.6.32-stable review patch.  If anyone has any objections, please let us know.

No objections.
