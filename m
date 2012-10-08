Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750977Ab2JHLyX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 07:54:23 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:39355 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab2JHLyV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 07:54:21 -0400
MIME-Version: 1.0
Message-ID: <ba3f7b37-cfac-4b54-8aa1-2d7cace0ce4b@default>
Date: Mon, 8 Oct 2012 04:54:08 -0700 (PDT)
From: Daniel Kiper <daniel.kiper@oracle.com>
To: <Ian.Campbell@citrix.com>
Cc: <konrad.wilk@oracle.com>, <Andrew.Cooper3@citrix.com>,
        <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>,
        <JBeulich@suse.com>
Subject: Re: [Xen-devel] [PATCH 01/11] kexec: introduce kexec_ops struct
X-Mailer: Zimbra on Oracle Beehive
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> On Mon, 2012-10-01 at 12:36 +0100, Daniel Kiper wrote:
> > On Fri, Sep 28, 2012 at 08:49:16AM +0100, Jan Beulich wrote:
> > > >>> On 27.09.12 at 20:06, Daniel Kiper <daniel.kiper@oracle.com> wrote:
> > > > Some kexec/kdump implementations (e.g. Xen PVOPS) on different archs could
> > > > not use default functions or require some changes in behavior of kexec/kdump
> > > > generic code. To cope with that problem kexec_ops struct was introduced.
> > > > It allows a developer to replace all or some functions and control some
> > > > functionality of kexec/kdump generic code.
> > >
> > > I'm not convinced that doing this at the architecture independent
> > > layer is really necessary/desirable. Nevertheless, if that's the right
> > > place, then everything else looks good to me, except for a
> > > cosmetic thing:
> >
> > I do not like this patch, too. However, this is the simplest
> > solution. If you do not do that in that way then you must
> > duplicate most of kernel/kexec.c functionality in architecture
> > depndent files.
>
> It would have been a good idea to CC the maintainer of those files
> directly with at least this patch if not the whole series.

Thanks. I spotted later that maintainers are not in CC.
I am going to prepare next version of patches with
minor suggested fixes and repost them once again
for review next week.

> If they don't like this approach then there not much point in doing a
> thorough reviewing of the other 10 patches I don't think, since I would
> expect they will be required to change pretty substantially under those
> circumstances.

Sure.

Daniel
