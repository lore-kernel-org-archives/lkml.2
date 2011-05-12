Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab1ELLRS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 07:17:18 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43449 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752607Ab1ELLRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 07:17:14 -0400
Date: Thu, 12 May 2011 12:17:51 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Amit Virdi <amit.virdi@st.com>
Cc: <samuel@sortiz.org>, <alan@linux.intel.com>, <davem@davemloft.net>,
        <eric.dumazet@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <shiraz.hashim@st.com>,
        <armando.visconti@st.com>, <viresh.kumar@st.com>
Subject: Re: [PATCH] net/irda/ircomm_tty.c: Use flip buffers to deliver data
Message-ID: <20110512121751.61d62446@lxorguk.ukuu.org.uk>
In-Reply-To: <1305198280-14449-1-git-send-email-amit.virdi@st.com>
References: <1305198280-14449-1-git-send-email-amit.virdi@st.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 May 2011 16:34:40 +0530
Amit Virdi <amit.virdi@st.com> wrote:

> use tty_insert_flip_string and tty_flip_buffer_push to deliver incoming data
> packets from the IrDA device instead of delivering the packets directly to the
> line discipline. Following later approach resulted in warning "Sleeping function
> called from invalid context".
> 
> Signed-off-by: Amit Virdi <amit.virdi@st.com>

Acked-by: Alan Cox <alan@linux.intel.com>

