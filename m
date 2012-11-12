Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab2KLPUL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 10:20:11 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:38596 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508Ab2KLPUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 10:20:08 -0500
Date: Mon, 12 Nov 2012 09:18:48 -0600
From: Kent Yoder <key@linux.vnet.ibm.com>
To: Peter.Huewe@infineon.com
Cc: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org
Subject: Re: [tpmdd-devel] [PATCH] tpm: add documentation for sysfs interfaces
Message-ID: <20121112151846.GA31987@ennui.austin.ibm.com>
References: <20121108171006.GA30286@ennui.austin.ibm.com>
 <74A44E99E3274B4CB570415926B37D440F6973@MUCSE501.eu.infineon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74A44E99E3274B4CB570415926B37D440F6973@MUCSE501.eu.infineon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12111215-3534-0000-0000-00000EDCE913
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Mon, Nov 12, 2012 at 08:47:55AM +0000, Peter.Huewe@infineon.com wrote:
> Hi Kent,
> 
> thanks a lot for this effort!
> I really appreciate it.
> 
> > +What:		/sys/class/misc/tpmX/device/active
> > +Date:		April 2006
> > +KernelVersion:	2.6.17
> > +Contact:	tpmdd-devel@lists.sf.net
> > +Description:	The "active" property prints a '1' if the TPM chip is accepting
> > +		commands. An inactive TPM chip still contains all the state of
> > +		an active chip (Storage Root Key, NVRAM, etc), and can be
> > +		visible to the OS, but will not accept commands.
> 
> Hmm, I know this is a tricky one (enabled/activated).
> maybe this would be better as:
> -		visible to the OS, but will not accept commands.
> +		visible to the OS, but will only accept a restricted set of commands.
> +		See TCG specification(...) for more information.

  Yeah that's more accurate. I'm just inclined to point to the design
principles and structures spec here unless you have a better idea. Both
have enabled/activated info scattered throughout them. Sigh. :)

> 
> 
> > +What:		/sys/class/misc/tpmX/device/cancel
> > +Date:		June 2005
> > +KernelVersion:	2.6.13
> > +Contact:	tpmdd-devel@lists.sf.net
> > +Description:	The "cancel" property allows you to cancel the currently
> > +		pending TPM command. Echoing any value to cancel will call the
> > +		TPM vendor specific cancel operation.
> 
> I'd go for writing instead of echoing but this might only be bike-shedding.
> -		pending TPM command. Echoing any value to cancel will call the
> +		pending TPM command. Writing any value to cancel will call the

  Sounds good.

Thanks,
Kent

> 
> The rest is great.
> Reviewed-by: Peter Huewe <peter.huewe@infineon.com>
> Signed-off-by: Peter Huewe <peter.huewe@infineon.com> 
> 	
> 
> Thanks,
> Peter
> 

