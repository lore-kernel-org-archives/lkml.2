Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758765Ab1FVSrD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 14:47:03 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:39573 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758746Ab1FVSqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 14:46:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=NKJh+8zZPfg7drfiD7DvTlBy6uHpHghligt8XY+jgoaGFQsZerOK4Zi+OeVvRfnePNi7nKQQACV6HkICsVNzvn6TRZ/5VWCXIpmPn4+8A7MASgx6XX5gRlhpxZvZ7p5p;
Date: Wed, 22 Jun 2011 11:46:47 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Margarita Olaya <magi@slimlogic.co.uk>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] mfd: tps65912 needs MFD_CORE
Message-Id: <20110622114647.0e8c1ec7.rdunlap@xenotime.net>
In-Reply-To: <20110622182915.GA13847@sirena.org.uk>
References: <20110622163651.7ebc407c.sfr@canb.auug.org.au>
	<20110622100615.c79765ff.randy.dunlap@oracle.com>
	<20110622182915.GA13847@sirena.org.uk>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jun 2011 19:29:15 +0100 Mark Brown wrote:

> On Wed, Jun 22, 2011 at 10:06:15AM -0700, Randy Dunlap wrote:
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > MFD_TPS65912 should select MFD_CORE so that mfd interfaces are
> > available to it.  This fixes a build error when MFD_CORE=m and
> > MFD_TPS65912=y (and no other TPS65912 kconfig symbols are enabled,
> > so no other select MFD_CORE was done).
> 
> I posted a better patch for this earlier today - the bigger problem here
> is that as with other MFD cores MFD_TPS65912 shouldn't be directly
> selectable at all as it can't do anything useful without a bus
> interface.

Good.  Hopefully such a kconfig won't be possible in the
future then.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
