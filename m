Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab1FHLPp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 07:15:45 -0400
Received: from lo.gmane.org ([80.91.229.12]:53204 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753114Ab1FHLPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 07:15:43 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Lukasz <el.es.cr@gmail.com>
Subject: [OT] Re: [PATCH 00/15] GMA500 KMS and GEM
Date: Wed, 8 Jun 2011 11:15:25 +0000 (UTC)
Message-ID: <loom.20110608T130453-800@post.gmane.org>
References: <20110608100411.9478.86672.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 81.139.79.252 (Mozilla/5.0 (Windows NT 5.1; rv:2.0.1) Gecko/20100101 Firefox/4.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan <at> lxorguk.ukuu.org.uk> writes:

> Vblank support is also possible but doesn't seem terribly useful.

Sorry for being gross off-topic.

But I see the vblank (the feature that lets the (whatever space) programs 
know when the vertical return occurs ?) as a quite useful thing...

Because then the rendering rate is (supposed to be) limited to whatever
the monitor supports (say 60Hz, 1 frame every 15ms) it may be useful as a 
comparision how much _free_ cpu time is left when the program
is ready for another frame, that including any (e.g. AI, engine or) system
tasks running (e.g. network communications, debugger)
IMvhO it so would be useful for tracing/profiling these apps, without
stress-testing and give you reproductible results for the performance
of your graphic engine... because there is plenty of time left 
for everything else and it does not step on each others toes or turning 
your machine into a (blow)heater :)

Just my thoughts.
L.

