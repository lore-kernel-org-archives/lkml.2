Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609Ab2GTVaJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 17:30:09 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:55758 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795Ab2GTVaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 17:30:06 -0400
Date: Fri, 20 Jul 2012 14:30:05 -0700 (PDT)
Message-Id: <20120720.143005.135422510157595877.davem@davemloft.net>
To: shuah.khan@hp.com
Cc: mcarlson@broadcom.com, bhutchings@solarflare.com, eric.dumazet@gmail.com,
        mchan@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com,
        stable@vger.kernel.org
Subject: Re: [PATCH RFT] net: Fix Neptune ethernet driver to check dma
 mapping error
From: David Miller <davem@davemloft.net>
In-Reply-To: <1342819679.5434.50.camel@lorien2>
References: <1342819679.5434.50.camel@lorien2>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shuah Khan <shuah.khan@hp.com>
Date: Fri, 20 Jul 2012 15:27:59 -0600

> Request for testing, since I don't have the hardware to test.

This is not how you post a patch.

> --------------------------------------------------------------------

When you put those "---..." there, GIT is going to eliminate everything
afterwards from the commit mesage when I apply this.  Yet afterwards
is what your commit message actually is.

You therefore should do things the other way around, provide the commit
message text, then the "---..." line, then your comments you don't want
in the final commit message.
