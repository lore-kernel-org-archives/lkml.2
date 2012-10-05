Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068Ab2JEN2B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 09:28:01 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:59923 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932634Ab2JEN1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 09:27:19 -0400
X-IronPort-AV: E=Sophos;i="4.80,541,1344211200"; 
   d="scan'208";a="14964350"
Message-ID: <1349443636.20946.96.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH 01/11] kexec: introduce kexec_ops struct
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Daniel Kiper <daniel.kiper@oracle.com>
CC: Jan Beulich <JBeulich@suse.com>, Andrew Cooper <Andrew.Cooper3@citrix.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        xen-devel <xen-devel@lists.xen.org>
Date: Fri, 5 Oct 2012 14:27:16 +0100
In-Reply-To: <20121001113046.GA2942@host-192-168-1-59.local.net-space.pl>
References: <1348769198-29580-1-git-send-email-daniel.kiper@oracle.com>
	 <1348769198-29580-2-git-send-email-daniel.kiper@oracle.com>
	 <5065729C020000780009E63B@nat28.tlf.novell.com>
	 <20121001113046.GA2942@host-192-168-1-59.local.net-space.pl>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-01 at 12:36 +0100, Daniel Kiper wrote:
> On Fri, Sep 28, 2012 at 08:49:16AM +0100, Jan Beulich wrote:
> > >>> On 27.09.12 at 20:06, Daniel Kiper <daniel.kiper@oracle.com> wrote:
> > > Some kexec/kdump implementations (e.g. Xen PVOPS) on different archs could
> > > not use default functions or require some changes in behavior of kexec/kdump
> > > generic code. To cope with that problem kexec_ops struct was introduced.
> > > It allows a developer to replace all or some functions and control some
> > > functionality of kexec/kdump generic code.
> >
> > I'm not convinced that doing this at the architecture independent
> > layer is really necessary/desirable. Nevertheless, if that's the right
> > place, then everything else looks good to me, except for a
> > cosmetic thing:
> 
> I do not like this patch, too. However, this is the simplest
> solution. If you do not do that in that way then you must
> duplicate most of kernel/kexec.c functionality in architecture
> depndent files.

It would have been a good idea to CC the maintainer of those files
directly with at least this patch if not the whole series.

If they don't like this approach then there not much point in doing a
thorough reviewing of the other 10 patches I don't think, since I would
expect they will be required to change pretty substantially under those
circumstances.

Ian.


