Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab2E3MQy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 08:16:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:44521 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124Ab2E3MQx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 08:16:53 -0400
Message-ID: <1338380201.26856.268.camel@twins>
Subject: Re: [PATCH] perf, x86: Make cycles:p working on SNB
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stephane Eranian <eranian@google.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>, Ingo Molnar <mingo@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
Date: Wed, 30 May 2012 14:16:41 +0200
In-Reply-To: <CABPqkBSwpUHYcq89K-DYwa-6+hV2zNN5t2_22VHV4ROVUWsoGA@mail.gmail.com>
References: <1337828525-1789-1-git-send-email-namhyung.kim@lge.com>
	 <1337844471.9783.48.camel@laptop>
	 <CABPqkBRcz1a738M7g484B0p-dJrKqP6GSLE7gpPN0H1w-72oWw@mail.gmail.com>
	 <1337845936.9783.57.camel@laptop>
	 <CABPqkBSwpUHYcq89K-DYwa-6+hV2zNN5t2_22VHV4ROVUWsoGA@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-24 at 09:58 +0200, Stephane Eranian wrote:
> > OK, so how about I queue the below and if the u-code updates gets
> > released before this hits Linus' tree we'll make it all go away ;-)
> >
> Let me get confirmation from Intel today before we do this. 

Any word from them?
