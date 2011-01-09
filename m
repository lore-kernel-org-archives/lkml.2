Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070Ab1AIXGd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 18:06:33 -0500
Received: from smtp.sgsi.ucl.ac.be ([130.104.5.67]:45237 "EHLO
	smtp4.sgsi.ucl.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab1AIXGc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 18:06:32 -0500
X-DKIM: Sendmail DKIM Filter v2.8.2 smtp4.sgsi.ucl.ac.be 9D241F2825
From: Christoph Paasch <christoph.paasch@uclouvain.be>
Reply-To: christoph.paasch@uclouvain.be
Organization: =?iso-8859-1?q?Universit=E9_Catholique_de?= Louvain
To: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] Cleanup include/net/tcp.h include-files and coding-style
Date: Mon, 10 Jan 2011 00:06:25 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.35-24-generic; KDE/4.5.5; x86_64; ; )
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1294606534-28522-1-git-send-email-christoph.paasch@uclouvain.be> <20110109223033.GA9485@p183.telecom.by> <201101092339.32378.christoph.paasch@uclouvain.be>
In-Reply-To: <201101092339.32378.christoph.paasch@uclouvain.be>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201101100006.26099.christoph.paasch@uclouvain.be>
X-Sgsi-Spamcheck: SASL authenticated, 
X-SGSI-MailScanner-ID: 9D241F2825.00000
X-SGSI-MailScanner: Found to be clean
X-SGSI-From: christoph.paasch@uclouvain.be
X-SGSI-Spam-Status: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sunday, January 09, 2011 wrote Christoph Paasch:
> BTW: shouldn't linux/tcp.h include linux/dmaengine.h ? It has a reference
> to "struct dma_pinned_list"
Ups, sorry for that. The include is at line 209.

I just looked at the head of linux/tcp.h ;)

Christoph

--
Christoph Paasch
PhD Student

IP Networking Lab --- http://inl.info.ucl.ac.be
MultiPath TCP in the Linux Kernel --- http://inl.info.ucl.ac.be/mptcp
Université Catholique de Louvain

www.rollerbulls.be
--
