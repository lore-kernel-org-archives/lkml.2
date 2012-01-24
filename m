Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab2AXQCO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 11:02:14 -0500
Received: from casper.infradead.org ([85.118.1.10]:45368 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522Ab2AXQCN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 11:02:13 -0500
Message-ID: <1327420925.2446.63.camel@twins>
Subject: Re: [PATCH 6/9] perf, tool: Add parser generator for events parsing
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Date: Tue, 24 Jan 2012 17:02:05 +0100
In-Reply-To: <1326717103-10287-7-git-send-email-jolsa@redhat.com>
References: <20120109152855.GA1597@m.brq.redhat.com>--suppress-cc=author>
	 <1326717103-10287-1-git-send-email-jolsa@redhat.com>
	 <1326717103-10287-7-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-16 at 13:31 +0100, Jiri Olsa wrote:
> +r{num_dec}             { return raw(10); }
> +r{num_hex}             { return raw(16); } 

Not sure that's compatible with the current stuff (not that I greatly
mind though), iirc rXXX is always hex.
