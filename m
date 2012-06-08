Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758051Ab2FHS3G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 14:29:06 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:43796 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755837Ab2FHS3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 14:29:04 -0400
Message-ID: <4FD24467.5030202@mev.co.uk>
Date: Fri, 8 Jun 2012 19:28:55 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120601 Thunderbird/12.0.1
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>
Subject: Re: linux-next: Tree for Jun 8 (comedi/das08.c)
References: <20120608144358.a83215ceb8212c55d37d21d0@canb.auug.org.au> <4FD230ED.5030901@xenotime.net>
In-Reply-To: <4FD230ED.5030901@xenotime.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-06-08 18:05, Randy Dunlap wrote:
> On 06/07/2012 09:43 PM, Stephen Rothwell wrote:
>
>> Hi all,
>>
>> Changes since 20120607:
>
>
>
> on i386, when CONFIG_PCI is not enabled:
>
> drivers/staging/comedi/drivers/das08.c: In function 'das08_attach':
> drivers/staging/comedi/drivers/das08.c:1084:3: error: implicit declaration of function 'das08_find_pci'
> drivers/staging/comedi/drivers/das08.c:1084:8: warning: assignment makes pointer from integer without a cast
> drivers/staging/comedi/drivers/das08.c:1087:3: error: implicit declaration of function 'das08_pci_attach_common'

Sorry about that.  I think I've accidentally fixed it already in a patch 
posted to <devel@driverdev.osuosl.org>, but I'll attach it to this 
thread as well.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
