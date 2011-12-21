Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab1LUVdv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 16:33:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38969 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214Ab1LUVds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 16:33:48 -0500
Date: Wed, 21 Dec 2011 16:33:42 -0500
From: Jason Baron <jbaron@redhat.com>
To: greg@kroah.com, Bart Van Assche <bvanassche@acm.org>
Cc: Jim Cromie <jim.cromie@gmail.com>, joe@perches.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/16] dynamic_debug: factor vpr_info_dq out of
 ddebug_parse_query
Message-ID: <20111221213341.GC30393@redhat.com>
References: <cover.1324318997.git.jbaron@redhat.com>
 <d3379e3504fcb51e666d85b0a7aef33f27e0c353.1324318997.git.jbaron@redhat.com>
 <CAO+b5-rZpHfB+OkHtsvBOaZx3tnLSCmBz=Md1+vY2hx+N2TLtA@mail.gmail.com>
 <CAJfuBxxrDp-1rPA5oR53Oy0OkZFvXTXHaBYL7+8n=ExCX3PtOg@mail.gmail.com>
 <CAO+b5-qMoL-BJupLAsstHDgfNwQTQXmDNUNjSn0ivxmD_j+ENQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAO+b5-qMoL-BJupLAsstHDgfNwQTQXmDNUNjSn0ivxmD_j+ENQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 03:49:54PM +0000, Bart Van Assche wrote:
> On Tue, Dec 20, 2011 at 3:47 PM, Jim Cromie <jim.cromie@gmail.com> wrote:
> > On Tue, Dec 20, 2011 at 1:17 AM, Bart Van Assche <bvanassche@acm.org> wrote:
> > > On Mon, Dec 19, 2011 at 10:13 PM, Jason Baron <jbaron@redhat.com> wrote:
> > >> From: Jim Cromie <jim.cromie@gmail.com>
> > >>
> > >> Factor pr_info(query) out of ddebug_parse_query, into pr_info_dq(),
> > >> for reuse later.  Also change the printed labels: file, func to agree
> > >> with the query-spec keywords accepted in the control file.  Pass ""
> > >> when string is null, to avoid "(null)" output from sprintf.  For
> > >> format print, use precision to skip last char, assuming its '\n', no
> > >> great harm if not, its a debug msg.
> > >
> > > pr_info_dq() or vpr_info_dq() ?
> >
> > I chose vpr_info_dq, with leading v to hint at the "if (verbose)" part
> 
> In case my reply was a little too terse: isn't there a letter "v"
> missing in the commit message ?
> 
> Bart.

Thanks for catching this.

Greg, if you want to s/pr_info_dq/vpr_info_dq, in the commit msg, this
one is all set.

Thanks,

-Jason
