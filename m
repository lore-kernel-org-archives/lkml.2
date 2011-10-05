Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935008Ab1JEQ1v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 12:27:51 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47257 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934922Ab1JEQ1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 12:27:50 -0400
Subject: Re: [RFCv3][PATCH 4/4] show page size in /proc/$pid/numa_maps
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, James.Bottomley@hansenpartnership.com,
        hpa@zytor.com
In-Reply-To: <1317828155.7842.73.camel@nimitz>
References: <20111001000856.DD623081@kernel>
	 <20111001000900.BD9248B8@kernel>
	 <alpine.DEB.2.00.1110042344250.16359@chino.kir.corp.google.com>
	 <1317798564.3099.12.camel@edumazet-laptop>
	 <1317828155.7842.73.camel@nimitz>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 Oct 2011 18:28:03 +0200
Message-ID: <1317832083.2473.58.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 05 octobre 2011 à 08:22 -0700, Dave Hansen a écrit :
> On Wed, 2011-10-05 at 09:09 +0200, Eric Dumazet wrote:
> > By the way, "pagesize=4KiB" are just noise if you ask me, thats the
> > default PAGE_SIZE. This also breaks old scripts :)
> 
> How does it break old scripts?
> 

Old scripts just parse numa_maps, and on typical machines where
hugepages are not used, they dont have to care about page size.
They assume pages are 4KB.

Adding a new word (pagesize=...) might break them, but personally I dont
care.



