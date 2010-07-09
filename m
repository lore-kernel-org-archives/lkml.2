Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758874Ab0GIAd7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 20:33:59 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:44447 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754534Ab0GIAd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 20:33:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=UZvpxFRP7Qm4H6XFIwgKC6J01TUsn/jnomR3nI903EHhXWbsV5qIXXaySR8TZA9x/6Y/PPBeYs9Kvk96a5Ncp1C43O8AhmWNGPGaJS60WU5irw4jwgT+h/AtoqP9gZXX;
Date: Thu, 8 Jul 2010 17:33:44 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Alex Chiang" <achiang@canonical.com>,
       "Ryan Wang" <openspace.wang@gmail.com>
Subject: Re: [Bug #16197] [BUG on 2.6.35-rc2] sysfs: cannot create duplicate
 filename '/devices/pci0000:00/0000:00:11.0/0000:02:03.0/slot'
Message-ID: <20100708173344.2d108ffd@virtuousgeek.org>
In-Reply-To: <TXb9XdQzJoD.A.5eD.pNmNMB@chimera>
References: <-IGZ64uxA6G.A.P0H.bLmNMB@chimera>
	<TXb9XdQzJoD.A.5eD.pNmNMB@chimera>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  9 Jul 2010 01:41:34 +0200 (CEST)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.34.  Please verify if it still should be listed and let the tracking team
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16197
> Subject		: [BUG on 2.6.35-rc2] sysfs: cannot create duplicate filename '/devices/pci0000:00/0000:00:11.0/0000:02:03.0/slot'
> Submitter	: Ryan Wang <openspace.wang@gmail.com>
> Date		: 2010-06-07 0:23 (32 days old)
> Message-ID	: <AANLkTincwMZPnYW3S4uz4k2GOn52RpgBIBRfzyD010Yo@mail.gmail.com>
> References	: http://marc.info/?l=linux-kernel&m=127587022219378&w=2

I thought this one was closed with the revert of the slot symlink?

-- 
Jesse Barnes, Intel Open Source Technology Center
