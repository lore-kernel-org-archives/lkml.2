Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438Ab2FNIDI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 04:03:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58314 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754392Ab2FNIDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 04:03:03 -0400
Date: Thu, 14 Jun 2012 10:02:53 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Mahmood Naderan <nt_mahmood@yahoo.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "\"linux-kernel@vger.kernel.org\"" <linux-kernel@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: logging on kernel panic
In-Reply-To: <1339599156.30833.YahooMailNeo@web111716.mail.gq1.yahoo.com>
Message-ID: <alpine.LNX.2.00.1206141001060.8644@pobox.suse.cz>
References: <1339589919.53487.YahooMailNeo@web111718.mail.gq1.yahoo.com> <20120613133927.73c44f09@pyramind.ukuu.org.uk> <alpine.LRH.2.00.1206131552440.6369@twin.jikos.cz> <1339599156.30833.YahooMailNeo@web111716.mail.gq1.yahoo.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jun 2012, Mahmood Naderan wrote:

> >and you can get the dmesg+panic from there
>  Sorry where? in the bios?

Read Documentation/ABI/testing/pstore in the kernel sources.

> @Cong:
> >The kernel log may not hit /var/log/syslog when kernel panics,
> Can I ask why. Just before a panic, kernel is still alive and can log. 

At the point of panic, the machine is too dead to be able to perform such 
a complex operation as writing to filesystem.

-- 
Jiri Kosina
SUSE Labs
