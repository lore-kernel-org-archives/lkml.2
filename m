Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932307Ab0JUOXY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 10:23:24 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:58712 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756515Ab0JUOXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 10:23:22 -0400
Date: Thu, 21 Oct 2010 07:23:19 -0700
From: Vernon Mauery <vernux@us.ibm.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Linux Documentation <linux-doc@vger.kernel.org>,
        Platform driver x86 <platform-driver-x86@vger.kernel.org>
Subject: Re: [Patch] IBM Real-Time "SMI Free" mode driver -v7
Message-ID: <20101021142319.GA8754@lucy>
References: <20101005224718.GC4046@lucy>
 <20101021135429.GC22133@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20101021135429.GC22133@srcf.ucam.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21-Oct-2010 02:54 PM, Matthew Garrett wrote:
>Applied, thanks. It'd be nice if we didn't have to rely on DMI,
>especially since enterprise customers often end up running later kernels

I am not sure what you mean here by problems with DMI running later 
kernels.

>- is there any other way to determine that this is safe to load? Could

I can't think of anything off the top of my head that would allow us to 
ensure that this is only loaded on IBM systems.  DMI is pretty good 
about that.

--Vernon

>we just limit it to IBM systems in a server/blade chassis and then check
>for the _RTL_ area?
>
>-- 
>Matthew Garrett | mjg59@srcf.ucam.org
>
