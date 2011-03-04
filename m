Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759449Ab1CDN6z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 08:58:55 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57053 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab1CDN6y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 08:58:54 -0500
Subject: Re: [PATCH] perf lock: clean the options for perf record
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
        linux-kernel@vger.kernel.org, h.mitake@gmail.com,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <20110304135635.GB1972@nowhere>
References: <1298388507-19774-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
	 <4D63D685.2010401@dcl.info.waseda.ac.jp> <1298389415.2217.243.camel@twins>
	 <20110222182206.GB1799@nowhere> <4D648A65.2040107@dcl.info.waseda.ac.jp>
	 <4D667D60.5010903@dcl.info.waseda.ac.jp> <20110224165014.GB1840@nowhere>
	 <4D67E286.8010907@dcl.info.waseda.ac.jp>
	 <AANLkTikUGO=Obm7Ue4VzEueQ7DERPiwci1VV9NmKZf1u@mail.gmail.com>
	 <4D70B3E1.8020108@dcl.info.waseda.ac.jp>  <20110304135635.GB1972@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 04 Mar 2011 14:58:19 +0100
Message-ID: <1299247099.24454.3.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-04 at 14:56 +0100, Frederic Weisbecker wrote:
> lockstat is a global measurement since the boot.

You can reset lockstat at any given time.
