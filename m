Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032616Ab2CSTGA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 15:06:00 -0400
Received: from na3sys010aog110.obsmtp.com ([74.125.245.88]:35344 "HELO
	na3sys010aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1032556Ab2CSTF6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 15:05:58 -0400
MIME-Version: 1.0
In-Reply-To: <CAOzFzEi=UOnwiV+qVks7+RnYU3PFbaQ+3OaEE3YFG2HHuD5ydQ@mail.gmail.com>
References: <CAOzFzEiufg40gKBH6D7zeB47SebfPvgzqOLxhF5eQqpYd-r4zQ@mail.gmail.com>
 <CAOzFzEi=UOnwiV+qVks7+RnYU3PFbaQ+3OaEE3YFG2HHuD5ydQ@mail.gmail.com>
From: Roland Dreier <roland@purestorage.com>
Date: Mon, 19 Mar 2012 12:05:36 -0700
Message-ID: <CAL1RGDVAd-LiS0sy6RAFNzkUuXrcuGv829nADcnxUnC2tfx3bw@mail.gmail.com>
Subject: Re: Kernel Panic with bonding + IPoIB on 3.2.9
To: Joseph Glanville <joseph.glanville@orionvm.com.au>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 18, 2012 at 1:21 PM, Joseph Glanville
<joseph.glanville@orionvm.com.au> wrote:
> [  422.047024] kernel BUG at net/core/dev.c:1896!

So this line is

        BUG_ON(offset >= skb_headlen(skb));

right?  No paritcular idea how we hit this, though...
