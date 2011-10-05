Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934118Ab1JEIyj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 04:54:39 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60311 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932659Ab1JEIyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 04:54:37 -0400
Subject: Re: [RFCv3][PATCH 4/4] show page size in /proc/$pid/numa_maps
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, James.Bottomley@hansenpartnership.com,
        hpa@zytor.com
In-Reply-To: <alpine.DEB.2.00.1110050012490.18906@chino.kir.corp.google.com>
References: <20111001000856.DD623081@kernel>
	 <20111001000900.BD9248B8@kernel>
	 <alpine.DEB.2.00.1110042344250.16359@chino.kir.corp.google.com>
	 <1317798564.3099.12.camel@edumazet-laptop>
	 <alpine.DEB.2.00.1110050012490.18906@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 Oct 2011 10:54:51 +0200
Message-ID: <1317804891.2473.26.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 05 octobre 2011 à 00:23 -0700, David Rientjes a écrit :

> Why on earth do we want to convert a byte value into a string so a script 
> can convert it the other way around?  Do you have a hard time parsing 
> 4096, 2097152, and 1073741824 to be 4K, 2M, and 1G respectively?  

Yes I do. I dont have in my head all possible 2^X values, but K, M, G,
T : thats ok (less neurons needed)

You focus on current x86_64 hardware.

Some arches have lot of different choices. (powerpc has 64K, 16M, 16GB
pages)

In 10 years, you'll have pagesize=549755813888, or maybe
pagesize=8589934592

I pretty much prefer pagesize=512GB and pagesize=8TB

This is consistent with usual conventions and practice.



