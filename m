Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758813Ab2C2Bb1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 21:31:27 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:32904 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758027Ab2C2BbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 21:31:18 -0400
MIME-Version: 1.0
Date: Wed, 28 Mar 2012 20:31:16 -0500
Message-ID: <CAMjP1Kka6MmT2zLc95ZQ=vigS6w9diS9-tawzdUdhbzzfzMh3w@mail.gmail.com>
Subject: Crash in __netif_receive_skb
From: Avleen Vig <avleen@gmail.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks, someone in #kernel recommended I email these two lists. Hope
they're the right place.

We're running 2.6.32-220.4.1.el6.x86_64 on Centos 6.2, and getting a
repeated crash:
    https://gist.github.com/2231998

We can make this happen pretty easily just by passing some network
traffic and waiting a while.
I couldn't find any references to this particular issue.
I have vmcore files and am happy to dig into it if it would help (as
long as someone can tell me what to do :))

Help?
