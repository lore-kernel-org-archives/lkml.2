Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420Ab1DXBto (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 21:49:44 -0400
Received: from ozlabs.org ([203.10.76.45]:44056 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757397Ab1DXBtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 21:49:42 -0400
Date: Sun, 24 Apr 2011 11:49:36 +1000
From: Anton Blanchard <anton@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, amodra@gmail.com
Subject: Re: [PATCH] perf annotate: Add config option for additional objdump
 arguments
Message-ID: <20110424114936.6729992e@kryten>
In-Reply-To: <20110416075415.GB19063@elte.hu>
References: <20110416164022.4ee0f8aa@kryten>
	<20110416075415.GB19063@elte.hu>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Ingo,

> Hm, could we please detect the required flags automatically and pass
> them along without forcing people into twiddling their ~/.perfconfig?
> 
> I don't mind the options patch either - but please first automate it,
> *then* add this as a quick fix for similar future problems.

Good point. Unfortunately there are some overlapping opcodes between
the ppc embedded and server chips but we could get most of the way
there by specifying using objdump -Many.

Anton
