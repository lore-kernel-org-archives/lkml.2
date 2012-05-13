Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380Ab2EMUKv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 16:10:51 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:49839 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab2EMUKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 16:10:50 -0400
Date: Sun, 13 May 2012 16:08:41 -0400 (EDT)
Message-Id: <20120513.160841.2185362023230844444.davem@davemloft.net>
To: jslaby@suse.cz
Cc: greg@kroah.com, jirislaby@gmail.com, stable@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        sedat.dilek@gmail.com, alexander.deucher@amd.com
Subject: Re: 3.3.5 regression: resume doesn't switch to X
From: David Miller <davem@davemloft.net>
In-Reply-To: <4FB0122E.4000603@suse.cz>
References: <4FAE0E88.2030703@suse.cz>
	<20120512154307.GA6023@kroah.com>
	<4FB0122E.4000603@suse.cz>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 13 May 2012 13:08:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>
Date: Sun, 13 May 2012 21:57:34 +0200

> On 05/12/2012 05:43 PM, Greg KH wrote:
>> On Sat, May 12, 2012 at 09:17:28AM +0200, Jiri Slaby wrote:
>>> Hi,
>> 
>> <side note, it's stable@vger.kernel.org, not stable@kernel.org>
> 
> Ah, fixed. Why it didn't bounce? Is it silently dropped?

vger.kernel.org kills it because it looks like SPAM or a looping
posting since it has Delivered-To: header fields in it when the
copy comes from stable@kernel.org

The kernel.org folks needs to really just take that email alias
down and turn it off, nothing from it makes the list for almost
a year now.  It's completely pointless.

