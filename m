Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311Ab1ARUXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 15:23:39 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55673 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745Ab1ARUXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 15:23:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=eaiu1u+a3rq2sqFYxqo6vxomdL/nezBxFwFCXyOwTe4LuFg5QFvoa3SmnnWk2yAyGW
         SiQbMKFQwjIPMaQUGPJoeDx1UXMq+DQD1tZoTxrQs/MCyL79boo9Q9TCE0KaGD8Pl6gr
         NUS3j38xkaw2FiKTZpHPAFeQ0cf9bhR7t3QfQ=
Subject: Re: [PATCH] af_unix: implement socket filter
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alban Crequy <alban.crequy@collabora.co.uk>
Cc: Ian Molton <ian.molton@collabora.co.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        ebiederm@xmission.com, xemul@openvz.org, davidel@xmailserver.org
In-Reply-To: <20110118175143.3a164669@chocolatine.cbg.collabora.co.uk>
References: <1295368755-20931-1-git-send-email-ian.molton@collabora.co.uk>
	 <1295371361.3290.15.camel@edumazet-laptop>
	 <20110118175143.3a164669@chocolatine.cbg.collabora.co.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Jan 2011 21:19:13 +0100
Message-ID: <1295381953.3194.1.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 18 janvier 2011 à 17:51 +0000, Alban Crequy a écrit :
> Le Tue, 18 Jan 2011 18:22:41 +0100,
> Eric Dumazet <eric.dumazet@gmail.com> a écrit :

> > Any idea on performance cost adding sk_filter() call ?
> 
> Ian will write a performance test and repost the patch with some stats.
> I don't know about the performance cost.

Dont spend time on this, it was more a question for myself ;)

Cost should be very small, unless complex filter is used, and I have a
JIT compiler for BPF on x86_64, will post it when net-next-2.6 reopens.



