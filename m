Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785Ab2KOVyv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 16:54:51 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:12074 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab2KOVys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 16:54:48 -0500
Message-ID: <1353011874.3055.22.camel@ejdallLaptop>
Subject: Re: turbostat tool update for Linux-3.8
From: Betty Dall <betty.dall@hp.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 15 Nov 2012 13:37:54 -0700
In-Reply-To: <1352925804-6746-1-git-send-email-lenb@kernel.org>
References: <1352925804-6746-1-git-send-email-lenb@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-11-14 at 15:43 -0500, Len Brown wrote:
> Here are some turbostat patches I have staged.
> The 1st two I've requested be pulled into 3.7,
> the rest are for 3.8
> 
> The final patch allows turbostat to print Watts
> as measured by hardware RAPL counters -- something
> that people have been asking for.
> 
> Please let me know if you see troubles with any of these patches.

Hi Len,

I tested out these patches on an IvyBridge system and see the new Watts
fields. They look like reasonable numbers to me. I ran with the system
idle and then with lookbusy -c 50 and saw the Watts increase. Is there
anything else to do to validate the numbers? In one case I saw that the
Pkg_W for the system was off by .01, e.g. socket 0 was 28.33 and socket
1 was 29.74 and the system total was 58.08 instead of 58.07. That is
probably fine and just rounding up.

-Betty

