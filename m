Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965013Ab2EOPPJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 11:15:09 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:9112 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757218Ab2EOPPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 11:15:07 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6711"; a="188826934"
Date: Tue, 15 May 2012 08:15:04 -0700
From: David Brown <davidb@codeaurora.org>
To: Shantanu Gupta <shans95g@gmail.com>
Cc: Daniel Walker <dwalker@fifo99.com>, Olof Johansson <olof@lixom.net>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] arm: msm: fix up very basic HTC Sapphire support
Message-ID: <20120515151504.GA2227@codeaurora.org>
References: <q7bdy899mt3um93hikst04au.1336884464056@email.android.com>
 <20120513055612.GA7129@codeaurora.org>
 <CAPDArRKgZKR2kdbt-ySx7GrXopNnN+j4hKr1rrDPgxkZ8S2YjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDArRKgZKR2kdbt-ySx7GrXopNnN+j4hKr1rrDPgxkZ8S2YjQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 03:49:00PM +0530, Shantanu Gupta wrote:

> Sorry for thread jacking, but do you still have an actively supported
> 8x50 board ? ( ie. mahimahi)

I still have a working 8x50 dev board (SURF), but I don't use it very
much, but I do test it occasionally.  None of my 8x50 phone-type
devices work any more.  It doesn't look like the mahimahi code has
ever been compiled, though.

If no one objects, I'll just send out a patch to remove the
board-mahimahi.c file, since nothing references it, and it doesn't
have very useful support, anyway.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
