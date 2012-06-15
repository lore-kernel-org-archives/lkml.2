Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093Ab2FOJ0n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 05:26:43 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53356 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075Ab2FOJ0m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 05:26:42 -0400
Message-ID: <1339752384.2559.44.camel@twins>
Subject: Re: [PATCH 1/6] perf, x86: Making hardware events tranlations sysfs
 available
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stephane Eranian <eranian@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>, acme@redhat.com, mingo@elte.hu,
        paulus@samba.org, cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org
Date: Fri, 15 Jun 2012 11:26:24 +0200
In-Reply-To: <CABPqkBRWyU2Y8B0d8n5fdm+OzGASoihRQmLnY3cUqRcV9MUwpA@mail.gmail.com>
References: <1339706321-8802-1-git-send-email-jolsa@redhat.com>
	 <1339706321-8802-2-git-send-email-jolsa@redhat.com>
	 <1339708192.2559.40.camel@twins>
	 <CABPqkBTjr2YiHYPT=32G-pqh6ca7BrtxcA8Nv-xFeG-eZrGtVA@mail.gmail.com>
	 <20120615072904.GA1767@m.brq.redhat.com>
	 <CABPqkBT4GPTp3k6Ko-t4Q5Kgz54O5yBZ7L+9M6Uc660rxTtrAA@mail.gmail.com>
	 <20120615074311.GA2650@m.brq.redhat.com>
	 <CABPqkBRWyU2Y8B0d8n5fdm+OzGASoihRQmLnY3cUqRcV9MUwpA@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-15 at 09:46 +0200, Stephane Eranian wrote:
> The kernel part should export the event with any of the terms that it exports
> thru sysfs for that CPU. 

ack
