Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650Ab1JBOu5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 10:50:57 -0400
Received: from mail.vyatta.com ([76.74.103.46]:33087 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752792Ab1JBOrN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 10:47:13 -0400
Date: Sun, 02 Oct 2011 07:47:12 -0700 (PDT)
From: Stephen Hemminger <stephen.hemminger@vyatta.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Willy Tarreau <w@1wt.eu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        starlight@binnacle.cx
Subject: Re: big picture UDP/IP performance question re 2.6.18 -> 2.6.32
Message-ID: <4cd3c66e-b0f1-440c-a170-a1df7d6a2691@tahiti.vyatta.com>
In-Reply-To: <1317540066.3802.32.camel@edumazet-laptop>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [50.53.80.93]
X-Mailer: Zimbra 7.1.1_GA_3213 (ZimbraWebClient - SAF3 (Linux)/7.1.1_GA_3196)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Try disabling PCI DMA remapping. The additional overhead of setting
up IO mapping can be a performance buzz kill. Try CONGIG_DMAR=n

