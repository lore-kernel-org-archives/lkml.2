Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758086Ab2BMWz6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 17:55:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:32994 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753895Ab2BMWz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 17:55:56 -0500
Message-ID: <4F3994DE.2040408@zytor.com>
Date: Mon, 13 Feb 2012 14:55:26 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Thomas Renninger <trenn@suse.de>, Ben Hutchings <ben@decadent.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Andi Kleen <ak@linux.intel.com>,
        linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
        linux-pm@vger.kernel.org, Dave Jones <davej@redhat.com>,
        cpufreq@vger.kernel.org
Subject: Re: [PATCH 0/5] Clean up x86 CPU auto-loading
References: <1329000256.325.48.camel@deadeye> <201202130010.57492.trenn@suse.de> <4F3866D4.9060209@zytor.com> <20120213222607.GA19465@kroah.com>
In-Reply-To: <20120213222607.GA19465@kroah.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2012 02:26 PM, Greg KH wrote:
> On Sun, Feb 12, 2012 at 05:26:44PM -0800, H. Peter Anvin wrote:
> 
> Ok, if there are no dependancies on the driver-core-next tree, please
> take this through the x86 trees.
> 

My mistake; I thought these changes were upstream already.  So yes,
please take them.

Acked-by: H. Peter Anvin <hpa@zytor.com>

	-hpa
-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

