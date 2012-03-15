Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761910Ab2COOsK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 10:48:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56946 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039Ab2COOsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 10:48:07 -0400
Message-ID: <4F62011D.4000708@zytor.com>
Date: Thu, 15 Mar 2012 07:47:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: linux-kernel@vger.kernel.org, x86@kernel.org, matt.fleming@intel.com
Subject: Re: [PATCH] EFI: Only set regions uncacheable if they support it
References: <1331819798-1955-1-git-send-email-mjg@redhat.com> <4F61F5E6.8060509@zytor.com> <20120315140708.GA3395@srcf.ucam.org> <4F61FA14.6020203@zytor.com> <20120315142445.GA4357@srcf.ucam.org> <4F61FC8E.8070109@zytor.com> <20120315143308.GA4382@srcf.ucam.org> <4F61FE7E.9060600@zytor.com> <20120315144236.GB4650@srcf.ucam.org>
In-Reply-To: <20120315144236.GB4650@srcf.ucam.org>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2012 07:42 AM, Matthew Garrett wrote:
> On Thu, Mar 15, 2012 at 07:36:46AM -0700, H. Peter Anvin wrote:
> 
>> I would still really like to understand why we're seeing #MCs... that's
>> bothersome all by itself.
> 
> The region is the legacy video RAM, so I can imagine there being 
> something magic about it.
> 

WTF?!  That should be UC at all times... it isn't even WC-capable.
Furthermore, we may need this region (assuming there is actually a video
card there.)

What do the fixed MTRRs look like?

	-hpa

