Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762194Ab2FHRGD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 13:06:03 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:60458 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1762175Ab2FHRGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 13:06:01 -0400
Message-ID: <4FD230ED.5030901@xenotime.net>
Date: Fri, 08 Jun 2012 10:05:49 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>
Subject: Re: linux-next: Tree for Jun 8 (comedi/das08.c)
References: <20120608144358.a83215ceb8212c55d37d21d0@canb.auug.org.au>
In-Reply-To: <20120608144358.a83215ceb8212c55d37d21d0@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2012 09:43 PM, Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20120607:



on i386, when CONFIG_PCI is not enabled:

drivers/staging/comedi/drivers/das08.c: In function 'das08_attach':
drivers/staging/comedi/drivers/das08.c:1084:3: error: implicit declaration of function 'das08_find_pci'
drivers/staging/comedi/drivers/das08.c:1084:8: warning: assignment makes pointer from integer without a cast
drivers/staging/comedi/drivers/das08.c:1087:3: error: implicit declaration of function 'das08_pci_attach_common'

-- 
~Randy
