Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760207Ab0GWR5N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 13:57:13 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:57057 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754083Ab0GWR5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 13:57:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=iSA95VmToL4aNErPRIVMkDGlaEl+Xgb6XRzJI9wcBU/Bf6hI1qUWnkM0n0ymlu0wCrXlEvUWescSImyxH7/7DcfsA5OvA7mDDat3cm3EFzNJg1wV6s7tdiQmB/k8br0t;
Date: Fri, 23 Jul 2010 10:57:24 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Tino Keitel <tino.keitel@tikei.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [Bug #16207] Suspend and VT switch hangs since 2.6.34
Message-ID: <20100723105724.043d8174@virtuousgeek.org>
In-Reply-To: <20100723175056.GA30411@x61.home>
References: <wQMMFC59mnE.A.v-E.iUYSMB@chimera>
	<PRbv8sgxY6G.A.j1F.aVYSMB@chimera>
	<20100723103336.539a3d61@virtuousgeek.org>
	<20100723175056.GA30411@x61.home>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jul 2010 19:50:56 +0200
Tino Keitel <tino.keitel@tikei.de> wrote:

> On Fri, Jul 23, 2010 at 10:33:36 -0700, Jesse Barnes wrote:
> 
> [...]
> 
> > I think this may actually be an X server bug.  2.6.34 introduced some
> 
> Hi,
> 
> that seems to be not a kernel issue indeed, as at some point I never
> got this hang again. However, I upgraded to new versions of Mesa, DRM,
> and also new bugfix releases of the Xserver (those in Debian unstable).

Great, we can close this one out then.  Thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
