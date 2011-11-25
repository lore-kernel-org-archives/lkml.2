Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab1KYKmz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 05:42:55 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46864 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694Ab1KYKmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 05:42:53 -0500
Message-ID: <1322217767.2403.2.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: TCP fast retransmit
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Esztermann, Ansgar" <Ansgar.Esztermann@mpi-bpc.mpg.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 25 Nov 2011 11:42:47 +0100
In-Reply-To: <A07B21E9-038F-49AB-A327-3E85BD45193D@mpi-bpc.mpg.de>
References: <A07B21E9-038F-49AB-A327-3E85BD45193D@mpi-bpc.mpg.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 25 novembre 2011 à 10:42 +0100, Esztermann, Ansgar a écrit :
> Hello list,
> 
> is there some documentation available on TCP fast retransmit? There
> seem to be quite a lot of descriptions -- from informal to scholarly
> papers -- on the various algorithms available to calculate the proper
> size of the congestion window, but I have been unable so far to find
> out *when* a fast retransmit is triggered. RFC 2581 states the third
> dupACK "should" do it, and this seems to be quoted fairly often.
> However, I can easily produce connections that fail to perform fast
> retransmit even after 5 dupACKs. Some people mention Linux uses a
> different (presumable more sophisticated) algorithm to trigger fast
> retransmits, but no-one seems to elaborate.
> 
I believe the RFC you gave should be the ground to your question.

Could you provide a trace showing what you believe is a violation of the
standards ?



