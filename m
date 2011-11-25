Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab1KYNJY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 08:09:24 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:40493 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142Ab1KYNJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 08:09:23 -0500
Message-ID: <1322226560.2403.16.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: TCP fast retransmit
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Esztermann, Ansgar" <Ansgar.Esztermann@mpi-bpc.mpg.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 25 Nov 2011 14:09:20 +0100
In-Reply-To: <1D4F412F-2623-47E6-AF5E-E7207DEE162C@mpi-bpc.mpg.de>
References: <A07B21E9-038F-49AB-A327-3E85BD45193D@mpi-bpc.mpg.de>
	 <1322217767.2403.2.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <1D4F412F-2623-47E6-AF5E-E7207DEE162C@mpi-bpc.mpg.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 25 novembre 2011 à 13:55 +0100, Esztermann, Ansgar a écrit :
> On Nov 25, 2011, at 11:42 , Eric Dumazet wrote:
> 
> > 
> > Could you provide a trace showing what you believe is a violation of the
> > standards ?
> 
> "Violation" is probably a bit on the harsh side (after all, it says "should"), but here goes (wireshark/libpcap format):
> The trace has been collected on 10.208.9.87. After one ACK plus five duplicates, a retransmission is triggered -- but it takes more than 200 ms, so that would be an ordinary retransmission. The original trace is (much) longer, but I've cut it down to keep the mail small. If required, I can provide more.

Ah, I missed the fact you sent your messages to
linux-kernel@vger.kernel.org.

Please start a new thread on netdev@vger.kernel.org to reach network
guys.



