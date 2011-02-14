Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab1BNUvO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 15:51:14 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34371
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751140Ab1BNUvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 15:51:12 -0500
Date: Mon, 14 Feb 2011 12:51:48 -0800 (PST)
Message-Id: <20110214.125148.59672184.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2011-02-14
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110214204406.GG2722@tuxdriver.com>
References: <20110214204406.GG2722@tuxdriver.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 14 Feb 2011 15:44:06 -0500

> A handful of fixes intended for 2.6.38...
> 
> This includes a couple of bluetooth device IDs, a bluetooth one-liner
> to avoid multiple connection responses, a locking fix to avoid some
> log spam, and a patch to turn off PCLP health checking for iwl3945
> (because the checking has not proven helpful and it kills performance).
> 
> Please let me know if there are problems!

Pulled, thanks John.
