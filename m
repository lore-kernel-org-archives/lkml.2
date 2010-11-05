Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751394Ab0KEGRc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 02:17:32 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53499 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab0KEGRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 02:17:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=SlzRtWPGDLeR6GtgE1s8rc8HcsB7itbWsVSBj2m1q1fexSshf/0dKZWgzke2ZdvY5n
         k7eWCByE6n9gWt3OmF9AqxX7EYPhDqNT0vhE1TQtgc01cIv+XfgsyOJ2q9qJC52rAE2Q
         sJM6hm/Ch9HmEKa0I7rtHuXM21waxCZLAiOa4=
Subject: Re: divide error in select_task_rq_fair()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Venkatesh Pallipadi <venki@google.com>, Nikhil Rao <ncrao@google.com>,
        Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101105020013.GA13484@helgaas.com>
References: <20101104041236.GA9389@helgaas.com>
	 <1288847992.2718.37.camel@edumazet-laptop>
	 <20101104142853.GA11656@helgaas.com>
	 <1288881474.2659.123.camel@edumazet-laptop>
	 <20101105020013.GA13484@helgaas.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Nov 2010 07:17:24 +0100
Message-ID: <1288937844.3234.1.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 04 novembre 2010 à 20:00 -0600, Bjorn Helgaas a écrit :

> Is that going to help you debug the problem?  The solution is not going
> to be something like "set NR_CPUS=x".  If NR_CPUS is too small, the
> machine should still *boot*, even if we can't use all the CPUs in the
> box.
> 

Yes, it will help to understand the layout of cpu / domains and make
appropriate changes.

Alternative is you send me such a machine :=)

Thanks


