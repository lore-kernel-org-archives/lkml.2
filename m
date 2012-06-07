Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932732Ab2FGSJA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 14:09:00 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:45520 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760930Ab2FGSI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 14:08:59 -0400
Date: Thu, 7 Jun 2012 14:01:56 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ben Guthro <ben@guthro.net>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] xen/hvc: Fix polling mode to work with
 kdb/kgdb
Message-ID: <20120607180156.GX9472@phenom.dumpdata.com>
References: <CAOvdn6VWdOy1nNM+x3ogCCFXy8FExZjTJaV-s6SR7kbGu+REOA@mail.gmail.com>
 <20120607164034.GQ9472@phenom.dumpdata.com>
 <CAOvdn6WJ+Ub+LbhHKKQJi3AzsbCqX6-ksWhoxnZS5_OH=hkghQ@mail.gmail.com>
 <20120607174815.GU9472@phenom.dumpdata.com>
 <CAOvdn6VtmWyMo4SEAWT+ipJTHBTwPm+DZ1TXZT4q3UobFv=2DA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOvdn6VtmWyMo4SEAWT+ipJTHBTwPm+DZ1TXZT4q3UobFv=2DA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2012 at 02:03:48PM -0400, Ben Guthro wrote:
> On Thu, Jun 7, 2012 at 1:48 PM, Konrad Rzeszutek Wilk
> <konrad.wilk@oracle.com> wrote:
> ...snip...
> 
> > Well, now that you guys are working for a big corporation
> > you can relax and afford to spend some time digging in the
> > inner-workings I think :-)
> 
> I'll pass along that suggestion.
> So far, that hasn't come to pass...
> 
> I understood it when I wrote this months ago. I really should have
> written this up then.
> I'll try to dig in a bit, and report back.

OK. Thanks!
