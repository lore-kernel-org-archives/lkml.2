Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627Ab2G0NPl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 09:15:41 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51456 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752358Ab2G0NPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 09:15:40 -0400
Date: Fri, 27 Jul 2012 15:15:36 +0200
From: Borislav Petkov <bp@alien8.de>
To: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
Cc: Cong Wang <xiyou.wangcong@gmail.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] netconsole.txt: "nc" needs "-p" to specify the
 listening port
Message-ID: <20120727131535.GA3485@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <gir4rxk7c2.fsf@mx10.gouders.net>
 <CAM_iQpX3EFnoW=Vh2hgJwNPr-whJhcUctCyv_+afFB8DrnHRsQ@mail.gmail.com>
 <gihastk13u.fsf@mx10.gouders.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <gihastk13u.fsf@mx10.gouders.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 11:24:53AM +0200, Dirk Gouders wrote:
> Cong Wang <xiyou.wangcong@gmail.com> writes:
> 
> > On Fri, Jul 27, 2012 at 2:35 PM, Dirk Gouders
> > <gouders@et.bocholt.fh-gelsenkirchen.de> wrote:
> >> Hi Jesse,
> >>
> >> I would like to ask you to check if the documentation of "nc" in
> >> netconsole.txt is still correct.  I tried two different netcat packages
> >> and both require "-p" to specify the listening port.  I am wondering if
> >> that changed after the use of "nc" has been documented.
> >
> > On Fedora 16, `nc -u -l <port number>` works fine.
> 
> Thanks for checking that.
> 
> If the information I found is correct, Fedora uses OpenBSD's nc
> codebase.  The two netcat packages I tested on a Gentoo system differ in
> requiring the -p switch for the port specification.

So say exactly that in the doc: that the *BSD's version of nc doesn't
need the port number specified with '-p' and you're covered.

-- 
Regards/Gruss,
Boris.
