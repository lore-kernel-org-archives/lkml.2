Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751207Ab2IXWWX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 18:22:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58859 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778Ab2IXWWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 18:22:22 -0400
Message-ID: <5060DD0B.1020707@zytor.com>
Date: Mon, 24 Sep 2012 15:22:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Joe Perches <joe@perches.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        levinsasha928@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: x86: "Fast TSC calibration failed" error
References: <1348488259.1436.22.camel@x61.thuisdomein>
In-Reply-To: <1348488259.1436.22.camel@x61.thuisdomein>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2012 05:04 AM, Paul Bolle wrote:
> 
> 4) So, without even understanding why tsc calibration is needed, it does
> look unnecessary to print "Fast TSC calibration failed" at error level.
> If that's correct, I'd be happy to submit the trivial patch to downgrade
> it to (say) informational level.
> 

Please do.

	-hpa

