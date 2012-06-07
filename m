Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952Ab2FGQam (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 12:30:42 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:54253 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752795Ab2FGQak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 12:30:40 -0400
Message-ID: <4FD0D724.40308@xenotime.net>
Date: Thu, 07 Jun 2012 09:30:28 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Mike Lockwood <lockwood@android.com>, devel@driverdev.osuosl.org
Subject: Re: linux-next: Tree for Jun 7 (staging/ccg)
References: <20120607131802.d90de854f06c5530c5fb2b33@canb.auug.org.au>
In-Reply-To: <20120607131802.d90de854f06c5530c5fb2b33@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2012 08:18 PM, Stephen Rothwell wrote:

> Hi all,
> 
> For the fist time in my memory, today's linux-next build required no
> manual intervention i.e. there are no new conflicts or build problems.
> 
> Changes since 20120604:


on x86_64:

In file included from drivers/staging/ccg/ccg.c:59:0:
drivers/staging/ccg/../../usb/gadget/f_fs.c:40:0: warning: "pr_vdebug" redefined
drivers/staging/ccg/../../usb/gadget/u_serial.c:138:0: note: this is the location of the previous definition

-- 
~Randy
