Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab2FSIfh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 04:35:37 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:38170 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753963Ab2FSIfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 04:35:32 -0400
Message-ID: <4FE039CD.8070209@mev.co.uk>
Date: Tue, 19 Jun 2012 09:35:25 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120616 Thunderbird/13.0
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] staging: comedi: Kconfig: menuconfig options should
 be bool not tristate
References: <201206151520.04455.hartleys@visionengravers.com> <20120618235902.GA29679@kroah.com> <ADE657CA350FB648AAC2C43247A983F0020698DBD3D0@AUSP01VMBX24.collaborationhost.net> <20120619003047.GA25098@kroah.com> <ADE657CA350FB648AAC2C43247A983F0020698DBD3D9@AUSP01VMBX24.collaborationhost.net>
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F0020698DBD3D9@AUSP01VMBX24.collaborationhost.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-06-19 02:01, H Hartley Sweeten wrote:
> On Monday, June 18, 2012 5:31 PM, Greg KH wrote:
>> Below is the .config I use.  Apply your patch, and select 'y' for the
>> different options it asks for when running 'make oldconfig' and then see
>> the build errors.
>
> Ok. It looks like the patch below should fix it. Can you test it?
>   config COMEDI_ADL_PCI7296
>   	tristate "ADLink PCI-7296 96 ch. digital io board support"
> +	select COMED_8255
>   	---help---
>   	  Enable support for ADlink PCI-7296 96 ch. digital io board support

That one has a typo bug.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-


