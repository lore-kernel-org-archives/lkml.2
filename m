Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758754Ab2CaKZB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 06:25:01 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:47400 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756961Ab2CaKY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 06:24:58 -0400
Subject: Re: [PATCH v5 2/2] Ethernet driver for the WIZnet W5100 chip
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Mike Sinkovsky <msink@permonline.ru>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <4F76D3E5.6050605@permonline.ru>
References: <1332752876-1650-1-git-send-email-msink@permonline.ru>
	 <1333090806-27988-2-git-send-email-msink@permonline.ru>
	 <1333099431.19659.15.camel@edumazet-laptop>
	 <4F76D3E5.6050605@permonline.ru>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 31 Mar 2012 12:24:53 +0200
Message-ID: <1333189493.2325.3392.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-03-31 at 15:52 +0600, Mike Sinkovsky wrote:


> Maybe, but I cannot test this, sorry - when I set breakpoint on this 
> branch - it never triggered, on all my tests on all boards.
> Appears that my processor is too slow and cannot feed packets fast enough.

Really ?

A pktgen script should certainly hit your NIC limit, unless this is a
100Gbit link ...



