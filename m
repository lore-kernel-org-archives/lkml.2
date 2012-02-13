Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab2BMGp2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 01:45:28 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:49604 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751476Ab2BMGp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 01:45:26 -0500
X-Sasl-enc: HR9hLa7LYDadAA1FPGLZgsXq/DD6NGilDJQWGjqR65v9 1329115525
Date: Sun, 12 Feb 2012 22:43:08 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Renninger <trenn@suse.de>, Ben Hutchings <ben@decadent.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Andi Kleen <ak@linux.intel.com>,
        linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
        linux-pm@vger.kernel.org, Dave Jones <davej@redhat.com>,
        cpufreq@vger.kernel.org
Subject: Re: [PATCH 0/5] Clean up x86 CPU auto-loading
Message-ID: <20120213064308.GB28617@kroah.com>
References: <1329000256.325.48.camel@deadeye>
 <201202130010.57492.trenn@suse.de>
 <20120213021847.GA25382@kroah.com>
 <4F387CCF.7040604@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F387CCF.7040604@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 12, 2012 at 07:00:31PM -0800, H. Peter Anvin wrote:
> On 02/12/2012 06:18 PM, Greg KH wrote:
> > I can take them, unless the x86 maintainers object and want to take them
> > through their tree.
> 
> Why don't we take them... I think it makes more sense long-term.

Ok, but for some reason I thought they depended on the patches already
in my driver-core-next tree.  If that's not the case, please feel free
to take them through yours.

greg k-h
