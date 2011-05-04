Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234Ab1EDSfY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 14:35:24 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:51213 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751878Ab1EDSfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 14:35:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=UMAUXYAlcHee+FtYD8szsiiumEHI23TKKa8FwkYKu2oQjxiYpGvwOehoOo4eTO2g+kWwlWjs7BGQXdttqHfUG9xfxXAdn7qkrlM6OaE4LtXFrXZ1ML8s530B9hY9FGSz;
Date: Wed, 4 May 2011 11:35:21 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: TB <lkml@techboom.com>, netdev <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Divide error in bictcp_cong_avoid ?
Message-Id: <20110504113521.3c506a54.rdunlap@xenotime.net>
In-Reply-To: <20110504113351.4643a0c9@nehalam>
References: <4DC178D3.6030308@techboom.com>
	<20110504104940.cd0d9e9a.rdunlap@xenotime.net>
	<20110504113351.4643a0c9@nehalam>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 May 2011 11:33:51 -0700 Stephen Hemminger wrote:

> On Wed, 4 May 2011 10:49:40 -0700
> Randy Dunlap <rdunlap@xenotime.net> wrote:
> 
> > [add cc to netdev]
> > 
> > 
> > On Wed, 04 May 2011 12:03:31 -0400 TB wrote:
> > 
> > > We're having this issue sporadically on a few servers and this is the 
> > > backtrace we get from netconsole.
> > > 
> > > 
> > > [28522.642419] divide error: 0000 [#1] SMP
> > > [28522.642457] last sysfs file: 
> > > /sys/devices/pci0000:00/0000:00:1f.2/host2/target2:0:0/2:0:0:0/vendor
> > > [28522.642504] CPU 0
> > > [28522.642511] Modules linked in:
> > >   i2c_i801
> > >   i2c_core
> > >   evdev
> > >   button
> > > [28522.642570]
> > > [28522.642590] Pid: 0, comm: swapper Not tainted 2.6.38.5 #6   <<<<<<<<<<<<<<
> > > 
> > >   Supermicro X8DTH-i/6/iF/6F
> > > /
> > >   X8DTH
> > > 
> 
> What kernel version? I suspect they are running something really old
> kernel like RHEL 5 since BIC has not been the default congestion control for
> several years.

Please see about 6 lines above.... at the "<<<<<<<<<<<".


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
