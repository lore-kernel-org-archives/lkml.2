Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127Ab2DTVEA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 17:04:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40731 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab2DTVD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 17:03:59 -0400
Date: Fri, 20 Apr 2012 14:03:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: shuahkhan@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>,
        Richard Purdie <richard.purdie@linuxfoundation.org>
Subject: Re: [PATCH] leds: change ledtrig-timer to use activated flag
Message-Id: <20120420140357.e58682a0.akpm@linux-foundation.org>
In-Reply-To: <1334953045.3255.17.camel@lorien2>
References: <1334703911.2655.9.camel@lorien2>
	<20120417161239.57c41966.akpm@linux-foundation.org>
	<1334893688.3051.5.camel@lorien2>
	<1334953045.3255.17.camel@lorien2>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2012 14:17:25 -0600
Shuah Khan <shuahkhan@gmail.com> wrote:

> Changed existing timer trigger to use activated flag to set activate 
> successful status in activate routine and check it in deactivate 
> routine to do cleanup.

Thanks.  I dropped "leds: ledtrig-timer trigger_data allocation fix" as
these patches conflict, and I believe that "leds: ledtrig-timer
trigger_data allocation fix" is no longer needed?

