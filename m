Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934114Ab1JEI57 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 04:57:59 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53261 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932659Ab1JEI55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 04:57:57 -0400
Subject: Re: [PATCH v5 6/8] tcp buffer limitation: per-cgroup limit
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, paul@paulmenage.org, lizf@cn.fujitsu.com,
        kamezawa.hiroyu@jp.fujitsu.com, ebiederm@xmission.com,
        davem@davemloft.net, gthelen@google.com, netdev@vger.kernel.org,
        linux-mm@kvack.org, kirill@shutemov.name, avagin@parallels.com,
        devel@openvz.org
In-Reply-To: <4E8C1064.3030902@parallels.com>
References: <1317730680-24352-1-git-send-email-glommer@parallels.com>
	 <1317730680-24352-7-git-send-email-glommer@parallels.com>
	 <1317732535.2440.6.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <4E8C1064.3030902@parallels.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 Oct 2011 10:58:10 +0200
Message-ID: <1317805090.2473.28.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 05 octobre 2011 à 12:08 +0400, Glauber Costa a écrit :
> On 10/04/2011 04:48 PM, Eric Dumazet wrote:

> > 2) Could you add const qualifiers when possible to your pointers ?
> 
> Well, I'll go over the patches again and see where I can add them.
> Any specific place site you're concerned about?

Everywhere its possible : 

It helps reader to instantly knows if a function is about to change some
part of the object or only read it, without reading function body.



