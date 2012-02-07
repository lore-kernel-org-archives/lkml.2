Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab2BGOim (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 09:38:42 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44420 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab2BGOil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 09:38:41 -0500
Date: Tue, 7 Feb 2012 12:38:31 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Stephane Eranian <eranian@google.com>
Cc: David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, mingo@elte.hu, robert.richter@amd.com,
        ming.m.lin@intel.com, andi@firstfloor.org, asharma@fb.com,
        ravitillo@lbl.gov, vweaver1@eecs.utk.edu, khandual@linux.vnet.ibm.com
Subject: Re: [PATCH v5 14/18] perf: fix endianness detection in perf.data
Message-ID: <20120207143831.GA2172@infradead.org>
References: <1328187288-24395-1-git-send-email-eranian@google.com>
 <1328187288-24395-15-git-send-email-eranian@google.com>
 <20120206181704.GF6367@infradead.org>
 <4F304A66.8050803@gmail.com>
 <20120206220651.GA16861@infradead.org>
 <4F305450.5020905@gmail.com>
 <CABPqkBSqy6rCVi8X8NPOuNOECgxd8N6BNhB6aA4nvKkV6=YQ4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABPqkBSqy6rCVi8X8NPOuNOECgxd8N6BNhB6aA4nvKkV6=YQ4w@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Feb 07, 2012 at 03:13:54PM +0100, Stephane Eranian escreveu:
> On Mon, Feb 6, 2012 at 11:29 PM, David Ahern <dsahern@gmail.com> wrote:
> > On 02/06/2012 03:06 PM, Arnaldo Carvalho de Melo wrote:
> >> Em Mon, Feb 06, 2012 at 02:47:18PM -0700, David Ahern escreveu:
> >>> On 02/06/2012 11:17 AM, Arnaldo Carvalho de Melo wrote:
> >>>> Looks ok, but IIRC David Ahern interacted with you on this specific
> >>>> patch in the past, having his Acked-by and/or Tested-by would be great,
> >>>> David?
> >>>
> >>> I don't recall anything changing since version 4. I scanned over the
> >>> change and it all looks familiar; testing worked fine as well -- I was
> >>> able to analyze a PPC file on x86 and vice versa.
> >>>
> >>> Acked-by: David Ahern <dsahern@gmail.com>
> >>> Tested-by: David Ahern <dsahern@gmail.com>
> >>
> >> Stephane,
> >>
> >>       What are your plans? A v6 patch series with this new round of
> >> comments and Acked-by et al stamps?
> >>
> I can do that. That'll be easier I think.

Nevermind, as David pointed out, it is standalone, I've applied it,
together with David's stamps.
 
> > I thought this one was standalone, so it could be picked up now.

- Arnaldo
