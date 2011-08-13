Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359Ab1HMOp1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 10:45:27 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:48560 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075Ab1HMOp0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 10:45:26 -0400
MIME-Version: 1.0
In-Reply-To: <20110813143903.GQ4775@n2100.arm.linux.org.uk>
References: <201108131556.27301.anarsoul@gmail.com>
	<1313240299-24712-1-git-send-email-anarsoul@gmail.com>
	<CAHkRjk4p1kqwKGiW_XRFU0aap98QkvRGRs0hwsBR4CcfM5RKqA@mail.gmail.com>
	<20110813143903.GQ4775@n2100.arm.linux.org.uk>
Date: Sat, 13 Aug 2011 15:45:25 +0100
X-Google-Sender-Auth: A2H0hn_McPRhWafLBQtdNyBhkuU
Message-ID: <CAHkRjk5aK7kkfpCoTqtwgkM8hjJx5MfD-Z7stXmqyWSz4VE56g@mail.gmail.com>
Subject: Re: [PATCH] Fix non-LPAE boot regression.
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Vasily Khoruzhick <anarsoul@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 13 August 2011, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Sat, Aug 13, 2011 at 03:14:30PM +0100, Catalin Marinas wrote:
>> Thanks for this. The original code was indeed broken but I think the
>> fix should be to use SECTION_SIZE instead of SHIFT. I'll have a look
>> on Monday.
>
> No, the original code is not broken.  Look at what it's doing:

I meant my original LPAE code (though strangely it was booting fine, I
guess it didn't use more than a section from those mappings). I'll
look at the details on Monday, I'm away from my PC now.

-- 
Catalin
