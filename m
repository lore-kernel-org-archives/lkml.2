Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371Ab2DTVQ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 17:16:28 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:20918 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366Ab2DTVQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 17:16:27 -0400
Message-ID: <1334956585.3255.18.camel@lorien2>
Subject: Re: [PATCH] leds: change ledtrig-timer to use activated flag
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: shuahkhan@gmail.com, LKML <linux-kernel@vger.kernel.org>,
        Richard Purdie <richard.purdie@linuxfoundation.org>
Date: Fri, 20 Apr 2012 15:16:25 -0600
In-Reply-To: <20120420140357.e58682a0.akpm@linux-foundation.org>
References: <1334703911.2655.9.camel@lorien2>
	 <20120417161239.57c41966.akpm@linux-foundation.org>
	 <1334893688.3051.5.camel@lorien2> <1334953045.3255.17.camel@lorien2>
	 <20120420140357.e58682a0.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-20 at 14:03 -0700, Andrew Morton wrote:
> On Fri, 20 Apr 2012 14:17:25 -0600
> Shuah Khan <shuahkhan@gmail.com> wrote:
> 
> > Changed existing timer trigger to use activated flag to set activate 
> > successful status in activate routine and check it in deactivate 
> > routine to do cleanup.
> 
> Thanks.  I dropped "leds: ledtrig-timer trigger_data allocation fix" as
> these patches conflict, and I believe that "leds: ledtrig-timer
> trigger_data allocation fix" is no longer needed?
> 

That is correct. It is no longer needed.

-- Shuah
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


