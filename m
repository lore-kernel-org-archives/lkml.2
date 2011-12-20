Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030Ab1LTPuB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 10:50:01 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:64484 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427Ab1LTPtz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 10:49:55 -0500
MIME-Version: 1.0
In-Reply-To: <CAJfuBxxrDp-1rPA5oR53Oy0OkZFvXTXHaBYL7+8n=ExCX3PtOg@mail.gmail.com>
References: <cover.1324318997.git.jbaron@redhat.com>
	<d3379e3504fcb51e666d85b0a7aef33f27e0c353.1324318997.git.jbaron@redhat.com>
	<CAO+b5-rZpHfB+OkHtsvBOaZx3tnLSCmBz=Md1+vY2hx+N2TLtA@mail.gmail.com>
	<CAJfuBxxrDp-1rPA5oR53Oy0OkZFvXTXHaBYL7+8n=ExCX3PtOg@mail.gmail.com>
Date: Tue, 20 Dec 2011 15:49:54 +0000
X-Google-Sender-Auth: XZobVmm5vWk2PqWP76LUIrArc7g
Message-ID: <CAO+b5-qMoL-BJupLAsstHDgfNwQTQXmDNUNjSn0ivxmD_j+ENQ@mail.gmail.com>
Subject: Re: [PATCH 15/16] dynamic_debug: factor vpr_info_dq out of ddebug_parse_query
From: Bart Van Assche <bvanassche@acm.org>
To: Jim Cromie <jim.cromie@gmail.com>
Cc: Jason Baron <jbaron@redhat.com>, greg@kroah.com, joe@perches.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 3:47 PM, Jim Cromie <jim.cromie@gmail.com> wrote:
> On Tue, Dec 20, 2011 at 1:17 AM, Bart Van Assche <bvanassche@acm.org> wrote:
> > On Mon, Dec 19, 2011 at 10:13 PM, Jason Baron <jbaron@redhat.com> wrote:
> >> From: Jim Cromie <jim.cromie@gmail.com>
> >>
> >> Factor pr_info(query) out of ddebug_parse_query, into pr_info_dq(),
> >> for reuse later.  Also change the printed labels: file, func to agree
> >> with the query-spec keywords accepted in the control file.  Pass ""
> >> when string is null, to avoid "(null)" output from sprintf.  For
> >> format print, use precision to skip last char, assuming its '\n', no
> >> great harm if not, its a debug msg.
> >
> > pr_info_dq() or vpr_info_dq() ?
>
> I chose vpr_info_dq, with leading v to hint at the "if (verbose)" part

In case my reply was a little too terse: isn't there a letter "v"
missing in the commit message ?

Bart.
