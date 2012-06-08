Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359Ab2FHDyw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 23:54:52 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:47116 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860Ab2FHDyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 23:54:50 -0400
Date: Thu, 07 Jun 2012 20:54:49 -0700 (PDT)
Message-Id: <20120607.205449.410840032205185493.davem@davemloft.net>
To: ben@decadent.org.uk
Cc: edumazet@google.com, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, gregkh@linuxfoundation.org,
        trond@chromium.org, pstew@chromium.org, grundler@chromium.org,
        allan@asix.com.tw
Subject: Re: [ 53/82] asix: allow full size 8021Q frames to be received
From: David Miller <davem@davemloft.net>
In-Reply-To: <1339122472.21665.103.camel@deadeye.wl.decadent.org.uk>
References: <20120607040344.002169511@linuxfoundation.org>
	<1339122472.21665.103.camel@deadeye.wl.decadent.org.uk>
X-Mailer: Mew version 6.5 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>
Date: Fri, 08 Jun 2012 03:27:52 +0100

> On Thu, 2012-06-07 at 13:04 +0900, Greg KH wrote:
>> 3.4-stable review patch.  If anyone has any objections, please let me know.
>> 
>> ------------------
>> 
>> 
>> From: Eric Dumazet <edumazet@google.com>
>> 
>> [ Upstream commit 9dae31009b1a00d926c6fe032d5a88099620adc3 ]
>> 
>> asix driver drops 8021Q full size frames because it doesn't take into
>> account VLAN header size.
>> 
>> Tested on AX88772 adapter.
> [...]
> 
> This should presumably go into earlier stable versions as well
> (specifically requested for 3.2 in <http://bugs.debian.org/676545>).
> 
> Does the attached backport look reasonable?

Yes, thanks Ben.
