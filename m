Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758464Ab0JUOZ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 10:25:26 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:40713 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441Ab0JUOZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 10:25:24 -0400
Date: Thu, 21 Oct 2010 15:25:23 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Vernon Mauery <vernux@us.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Linux Documentation <linux-doc@vger.kernel.org>,
        Platform driver x86 <platform-driver-x86@vger.kernel.org>
Subject: Re: [Patch] IBM Real-Time "SMI Free" mode driver -v7
Message-ID: <20101021142523.GA23171@srcf.ucam.org>
References: <20101005224718.GC4046@lucy> <20101021135429.GC22133@srcf.ucam.org> <20101021142319.GA8754@lucy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101021142319.GA8754@lucy>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 07:23:19AM -0700, Vernon Mauery wrote:
> On 21-Oct-2010 02:54 PM, Matthew Garrett wrote:
>> Applied, thanks. It'd be nice if we didn't have to rely on DMI,
>> especially since enterprise customers often end up running later kernels
>
> I am not sure what you mean here by problems with DMI running later  
> kernels.

Oops, sorry! I mean running on older kernels.

>> - is there any other way to determine that this is safe to load? Could
>
> I can't think of anything off the top of my head that would allow us to  
> ensure that this is only loaded on IBM systems.  DMI is pretty good  
> about that.

I'd suggest using DMI to verify that it's an IBM, and perhaps also using 
DMI to check that it's a server or blade rather than a laptop or 
desktop. After that you could just check the ebda rather than having to 
have an entry for every specific machine.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
