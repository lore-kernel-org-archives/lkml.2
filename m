Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758881Ab1ELWFE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 18:05:04 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:48878 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758736Ab1ELWFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 18:05:00 -0400
Date: Thu, 12 May 2011 18:03:03 -0400 (EDT)
Message-Id: <20110512.180303.182109841640606265.davem@davemloft.net>
To: alan@lxorguk.ukuu.org.uk
Cc: amit.virdi@st.com, samuel@sortiz.org, alan@linux.intel.com,
        eric.dumazet@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, shiraz.hashim@st.com,
        armando.visconti@st.com, viresh.kumar@st.com
Subject: Re: [PATCH] net/irda/ircomm_tty.c: Use flip buffers to deliver data
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110512121751.61d62446@lxorguk.ukuu.org.uk>
References: <1305198280-14449-1-git-send-email-amit.virdi@st.com>
	<20110512121751.61d62446@lxorguk.ukuu.org.uk>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 12 May 2011 15:03:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Thu, 12 May 2011 12:17:51 +0100

> On Thu, 12 May 2011 16:34:40 +0530
> Amit Virdi <amit.virdi@st.com> wrote:
> 
>> use tty_insert_flip_string and tty_flip_buffer_push to deliver incoming data
>> packets from the IrDA device instead of delivering the packets directly to the
>> line discipline. Following later approach resulted in warning "Sleeping function
>> called from invalid context".
>> 
>> Signed-off-by: Amit Virdi <amit.virdi@st.com>
> 
> Acked-by: Alan Cox <alan@linux.intel.com>

Applied to net-next-2.6, thanks.
