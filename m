Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965321Ab2CMAgs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:36:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10630 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965014Ab2CMAgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:36:45 -0400
Date: Tue, 13 Mar 2012 01:36:39 +0100
From: Jan Kratochvil <jan.kratochvil@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Roland McGrath <roland@hack.frob.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Kushal Das <kdas@redhat.com>
Subject: Re: Extending coredump note section to contain filenames
Message-ID: <20120313003639.GA18427@host2.jankratochvil.net>
References: <4F5A3A4D.1020008@redhat.com>
 <20120309172934.GA18173@host2.jankratochvil.net>
 <4F5DE6A4.2030303@redhat.com>
 <20120312165359.GA32400@host2.jankratochvil.net>
 <4F5E76CE.4030601@zytor.com>
 <20120312223144.GA9636@host2.jankratochvil.net>
 <4F5E91DE.80609@zytor.com>
 <20120313002725.GA17828@host2.jankratochvil.net>
 <4F5E956F.3070108@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F5E956F.3070108@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Mar 2012 01:31:43 +0100, H. Peter Anvin wrote:
> This is basically providing the dso_list and executable information.
> Several of the other things you list above (cmdline, environ, pid,
> reason, maps) are already part of a core file.

dso_list and executable identification (their build-id) are also part of the
core file.  It is only filesystem defect it can map filename -> content but it
cannot map build-id -> content.  There are many indexing solutions for it,
including slocate, when you have started to talk about not 100% reliable
solutions.


> The rest sounds like an RFE to me.

If you really mean all that info does belong to a core file then I no longer
have any objections, Linux kernel can put a lot of redundant info into the
core file.


Regards,
Jan
