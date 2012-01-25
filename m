Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768Ab2AYIm3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 03:42:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323Ab2AYIm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 03:42:28 -0500
Date: Wed, 25 Jan 2012 09:42:16 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/9] perf, tool: Add parser generator for events parsing
Message-ID: <20120125084216.GA2582@m.brq.redhat.com>
References: <20120109152855.GA1597@m.brq.redhat.com>
 <1326717103-10287-1-git-send-email-jolsa@redhat.com>
 <1326717103-10287-7-git-send-email-jolsa@redhat.com>
 <1327420925.2446.63.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327420925.2446.63.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 05:02:05PM +0100, Peter Zijlstra wrote:
> On Mon, 2012-01-16 at 13:31 +0100, Jiri Olsa wrote:
> > +r{num_dec}             { return raw(10); }
> > +r{num_hex}             { return raw(16); } 
> 
> Not sure that's compatible with the current stuff (not that I greatly
> mind though), iirc rXXX is always hex.
right, I'll fix it
thanks
