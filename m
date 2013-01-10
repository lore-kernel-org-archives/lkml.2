Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab3AJPel (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 10:34:41 -0500
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:62554 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754541Ab3AJPdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 10:33:00 -0500
Message-ID: <1357831978.1320.9.camel@x61.thuisdomein>
Subject: Re: [ 000/123] 3.7.2-stable review
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Date: Thu, 10 Jan 2013 16:32:58 +0100
In-Reply-To: <20130109201458.392601412@linuxfoundation.org>
References: <20130109201458.392601412@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Jan 2013 15:32:58.0382 (UTC) FILETIME=[C49AFAE0:01CDEF47]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-09 at 12:33 -0800, Greg Kroah-Hartman wrote:
> Note, there are still a lot of patches submitted for inclusion in the
> stable releases that I have not gotten to yet.  I wanted to get this
> release out now, instead of delaying for a week or so while I dig
> through all of the pending patches.
> 
> This is the start of the stable review cycle for the 3.7.2 release.
> There are 123 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri Jan 11 20:11:16 UTC 2013.
> Anything received after that time might be too late.

My first build of v3.7.2-rc1 panics at boot (on x86_64). I haven't
investigated in depth what happened, so this can even be something dumb
on my side during build. For what's worth the (last?) backtrace starts
with (copied manually):
    WARNING at arch/x86/kernel/apic/ipi.c:113 default_send_IPI_mask_logical+0xde/0xf0().

But there seems to be preceding trouble.

I hope to dive in deeper later this day (perhaps I can catch this panic
over a serial line). Currently I have no idea what's going on.


Paul Bolle

