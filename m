Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860Ab0DLTdL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 15:33:11 -0400
Received: from straum.hexapodia.org ([207.7.131.186]:46535 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615Ab0DLTdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 15:33:08 -0400
Date: Mon, 12 Apr 2010 12:33:06 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Matthew Wilcox <willy@linux.intel.com>, Yinghai Lu <yinghai@kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [2.6.34-rc1 REGRESSION] ahci 0000:00:1f.2: controller reset
	failed (0xffffffff)
Message-ID: <20100412193306.GM11130@hexapodia.org>
References: <20100406225425.GA8292@hexapodia.org> <1270612783.8518.15.camel@dc7800.home> <201004121156.41716.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004121156.41716.bjorn.helgaas@hp.com>
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 12, 2010 at 11:56:41AM -0600, Bjorn Helgaas wrote:
> But I'd still like to see the details of what ACPI is telling us,
> so if you wouldn't mind trying that patch from bugzilla:
>   https://bugzilla.kernel.org/show_bug.cgi?id=15533#c5
> and collecting an acpidump, and attaching both to the bug report:
>   https://bugzilla.kernel.org/show_bug.cgi?id=15744
> that would be great.

That's confusing, I think I figured it out but "try this patch" which
links to a message that refers to another patch and some commandline
options and some config options and doesn't say what the goal is, is a
lot for me to parse since I don't actually understand what's going on
here.

I think I got it all:
https://bugzilla.kernel.org/attachment.cgi?id=25969
https://bugzilla.kernel.org/attachment.cgi?id=25970

Let me know (using small words if necessary) if I screwed something up.

Thanks,
-andy
