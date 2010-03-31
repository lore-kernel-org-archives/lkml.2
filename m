Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932860Ab0CaM3g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 08:29:36 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:62368 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032Ab0CaM3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 08:29:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ZWu1ukA25qTAQvBASJwV9RjsvYroLvlq2QGtqCKA5pRmHXLqP7HFRBGQt0OxlaJsbK
         Q4P6IOrH9z1sBSyqlcwUVcpfljcInhgq3PXHRFCav1log/x9cg2cfvkIL5b2B0le+Usu
         U6oiIBAUyIlXO0Bk5hCk9UrMGy7CxP4tSWt4A=
Subject: Re: [r8169] WARNING: at net/sched/sch_generic.c
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Neil Horman <nhorman@redhat.com>, netdev@vger.kernel.org,
       Francois Romieu <romieu@fr.zoreil.com>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
In-Reply-To: <20100331121426.GB3294@swordfish.minsk.epam.com>
References: <20100331102142.GA3294@swordfish.minsk.epam.com>
	 <20100331111942.GB13963@hmsreliant.think-freely.org>
	 <20100331121426.GB3294@swordfish.minsk.epam.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 31 Mar 2010 14:29:29 +0200
Message-ID: <1270038569.2103.24.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 31 mars 2010 à 15:14 +0300, Sergey Senozhatsky a écrit :


> PKT_SIZE="pkt_size 2048"
> 

If you use 1024 bytes pktgen messages, do you still have the problem ?


