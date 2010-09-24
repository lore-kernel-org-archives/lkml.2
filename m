Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463Ab0IXFm4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 01:42:56 -0400
Received: from szamchat.xatka.net ([195.137.246.111]:50543 "EHLO
	szamchat.xatka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464Ab0IXFmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 01:42:53 -0400
Date: Fri, 24 Sep 2010 07:40:00 +0200
From: =?iso-8859-2?Q?Pawe=B3?= Zuzelski <pawelz@pld-linux.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: =?iso-8859-2?Q?Pawe=B3?= Zuzelski <pawelz@pld-linux.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
        lkml <linux-kernel@vger.kernel.org>,
        James Dingwall <james.dingwall@amdocs.com>
Subject: Re: [Xen-devel] PROBLEM: [BISECTED] 2.6.35.5 xen domU panics just
 after	the boot
Message-ID: <20100924054000.GA4689@pzz.touk.pl>
References: <20100921190525.GD4573@davabel.touk.pl>
 <4C9BEA8C.2030808@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4C9BEA8C.2030808@goop.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Sep 2010, Jeremy Fitzhardinge wrote:

>  On 09/21/2010 12:05 PM, Pawe³ Zuzelski wrote:
> > Hello,
> >
> > kernels 2.6.35.5 and 2.6.32.22 xen domU panics at the very begining of the
> > boot process.
> >
> > I have bisected it to a single commit, and the first bad commit is:
> > [fb412a178502dc498430723b082a932f797e4763] xen: use percpu interrupts for IPIs and VIRQs
> >
> > kernel v2.6.35.5 with reverted this commit works for me.
> 
> Thanks very much for doing that.  I'll have to work out what's going on
> (obviously it doesn't do it for me).

Have you seen the message from James Dingwall?

He had found the typo in fb412a178502dc498430723b082a932f797e4763
commit and sent the patch to lkml that fixes it.

Please, see https://patchwork.kernel.org/patch/202282/ if you have
not received James' mail. That patch resolves the problem for me and
for James.

-- 
Regards,
Pawe³ Zuzelski
