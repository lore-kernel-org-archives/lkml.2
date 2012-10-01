Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab2JAKdE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 06:33:04 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:4474 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753304Ab2JAKc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 06:32:59 -0400
Message-ID: <1349087577.24442.21.camel@x61.thuisdomein>
Subject: Re: [PATCH] regmap: silence GCC warning
From: Paul Bolle <pebolle@tiscali.nl>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Date: Mon, 01 Oct 2012 12:32:57 +0200
In-Reply-To: <20121001101859.GC4360@opensource.wolfsonmicro.com>
References: <1349000155.1553.27.camel@x61.thuisdomein>
	 <20121001100321.GB4360@opensource.wolfsonmicro.com>
	 <1349086606.24442.13.camel@x61.thuisdomein>
	 <20121001101859.GC4360@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Oct 2012 10:32:57.0672 (UTC) FILETIME=[1F9FDC80:01CD9FC0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-01 at 11:19 +0100, Mark Brown wrote:
> I haven't actually stared hard enough at the code to figure this out
> yet but given what you're changing I'd hope it's a flow analysis bug.
> I'm certainly not seeing a warning here.

Well, you may be using another version of gcc, or using different
defaults. I'm using gcc-4.7.2-2.fc17.x86_64 (ie, the gcc currently
shipped in Fedora 17 for x86_64), in what I think to be default
settings.

Note that it's not some local oddity. Looking at the (currently) latest
log for a Fedora build of v3.6-rc7 you'll find an identical warning [0].
Apparently that build was done with gcc-4.7.1-5.fc18.x86_64 [1].


Paul Bolle

[0] http://kojipkgs.fedoraproject.org/packages/kernel/3.6.0/0.rc7.git2.2.fc18/data/logs/x86_64/build.log
[1] http://kojipkgs.fedoraproject.org/packages/kernel/3.6.0/0.rc7.git2.2.fc18/data/logs/x86_64/root.log

