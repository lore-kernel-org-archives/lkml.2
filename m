Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932232Ab2AIPoO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 10:44:14 -0500
Received: from casper.infradead.org ([85.118.1.10]:43016 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932123Ab2AIPoK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 10:44:10 -0500
Message-ID: <1326123819.2442.86.camel@twins>
Subject: Re: new syntax for perf event
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Date: Mon, 09 Jan 2012 16:43:39 +0100
In-Reply-To: <20120109152855.GA1597@m.brq.redhat.com>
References: <1323963039-7602-1-git-send-email-jolsa@redhat.com>
	 <1323963039-7602-2-git-send-email-jolsa@redhat.com>
	 <1324044159.18942.104.camel@twins> <1324044196.18942.105.camel@twins>
	 <20111220103154.GA1861@m.brq.redhat.com> <1324378070.24621.32.camel@twins>
	 <1324380648.24621.49.camel@twins> <1324381161.24621.53.camel@twins>
	 <20111221161613.GA1659@m.brq.redhat.com> <1325772656.2697.57.camel@twins>
	 <20120109152855.GA1597@m.brq.redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-09 at 16:28 +0100, Jiri Olsa wrote:
> anyone working on the 'format' stuff? ;) I guess thats the place,
> where we can stay with hardcoded config[12] so far.. right?

Nobody afaik. Its just one of those things that would be nice to have
and are on the todo list someplace. So yeah, you can keep the hardcoded
config things for now.
