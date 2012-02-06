Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886Ab2BFWHB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 17:07:01 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42575 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317Ab2BFWHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 17:07:00 -0500
Date: Mon, 6 Feb 2012 20:06:51 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, mingo@elte.hu, robert.richter@amd.com,
        ming.m.lin@intel.com, andi@firstfloor.org, asharma@fb.com,
        ravitillo@lbl.gov, vweaver1@eecs.utk.edu, khandual@linux.vnet.ibm.com
Subject: Re: [PATCH v5 14/18] perf: fix endianness detection in perf.data
Message-ID: <20120206220651.GA16861@infradead.org>
References: <1328187288-24395-1-git-send-email-eranian@google.com>
 <1328187288-24395-15-git-send-email-eranian@google.com>
 <20120206181704.GF6367@infradead.org>
 <4F304A66.8050803@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F304A66.8050803@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Feb 06, 2012 at 02:47:18PM -0700, David Ahern escreveu:
> On 02/06/2012 11:17 AM, Arnaldo Carvalho de Melo wrote:
> > Looks ok, but IIRC David Ahern interacted with you on this specific
> > patch in the past, having his Acked-by and/or Tested-by would be great,
> > David?
> 
> I don't recall anything changing since version 4. I scanned over the
> change and it all looks familiar; testing worked fine as well -- I was
> able to analyze a PPC file on x86 and vice versa.
> 
> Acked-by: David Ahern <dsahern@gmail.com>
> Tested-by: David Ahern <dsahern@gmail.com>
> 

Stephane,

	What are your plans? A v6 patch series with this new round of
comments and Acked-by et al stamps?

- Arnaldo
