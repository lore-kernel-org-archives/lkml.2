Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932777Ab1LERiY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 12:38:24 -0500
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:41063 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932650Ab1LERiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 12:38:13 -0500
Message-ID: <4EDD0F60.5050201@xenotime.net>
Date: Mon, 05 Dec 2011 10:37:20 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Mark Einon <mark.einon@gmail.com>, Greg KH <gregkh@suse.de>
Subject: Re: linux-next: Tree for Dec 5 (staging/et131x)
References: <20111205154444.bf59a93a6b03cb4985850d82@canb.auug.org.au>
In-Reply-To: <20111205154444.bf59a93a6b03cb4985850d82@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2011 08:44 PM, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20111202:


on i386 (X86_32) builds:

drivers/staging/et131x/et131x.c:2483:8: warning: right shift count >= width of type
drivers/staging/et131x/et131x.c:2531:8: warning: right shift count >= width of type

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
