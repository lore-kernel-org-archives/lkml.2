Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751325Ab1HISMW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 14:12:22 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57060 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab1HISMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 14:12:21 -0400
Subject: Re: [Patch] scm: Capture the full credentials of the scm sender
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "David S. Miller" <davem@davemloft.net>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
In-Reply-To: <4E41772D.1070700@linux.intel.com>
References: <1312841316.2576.49.camel@schen9-DESK>
	 <1312857834.2531.15.camel@edumazet-laptop>
	 <1312908512.2576.97.camel@schen9-DESK>  <4E41772D.1070700@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Aug 2011 20:12:15 +0200
Message-ID: <1312913535.2547.6.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 09 août 2011 à 11:06 -0700, Andi Kleen a écrit :
> > This patch corrects an erroneous update of credential's gid with uid
> > introduced in commit 257b5358b32f17 since 2.6.36.
> 
> 
> Please also add a Cc: stable@kernel.org
> 

David handles stable submission himself, a priori.

Acked-by: Eric Dumazet <eric.dumazet@gmail.com>



