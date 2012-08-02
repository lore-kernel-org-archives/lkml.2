Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823Ab2HBOOD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 10:14:03 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37531 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594Ab2HBOOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 10:14:01 -0400
Subject: Re: Huge performance degradation for UDP between 2.4.17 and 2.6
From: Eric Dumazet <eric.dumazet@gmail.com>
To: leroy christophe <christophe.leroy@c-s.fr>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <501A722D.1070900@c-s.fr>
References: <501A722D.1070900@c-s.fr>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Aug 2012 16:13:56 +0200
Message-ID: <1343916836.9299.189.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-02 at 14:27 +0200, leroy christophe wrote:
> Hi
> 
> I'm having a big issue with UDP. Using a powerpc board (MPC860).
> 
> With our board running kernel 2.4.17, I'm able to send 160000 voice 
> packets (UDP, 96 bytes per packet) in 11 seconds.
> With the same board running either Kernel 2.6.35.14 or Kernel 3.4.7, I 
> need 55 seconds to send the same amount of packets.
> 
> 
> Is there anything to tune in order to get same output rate as with 
> Kernel 2.4 ?

kernel size is probably too big for your old / slow cpu.

Maybe you added too many features on your 3.4.7 kernel. (netfilter ?
SLUB debugging ...)

Its hard to say, 2.4.17 had less features and was faster.



