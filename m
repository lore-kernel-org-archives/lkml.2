Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757139Ab1LHAqN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 19:46:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53685 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756745Ab1LHAqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 19:46:12 -0500
Message-ID: <4EE008C6.70209@zytor.com>
Date: Wed, 07 Dec 2011 16:45:58 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Darren Hart <dvhart@linux.intel.com>
CC: "lkml, " <linux-kernel@vger.kernel.org>,
        Matt Fleming <matt.fleming@linux.intel.com>,
        Edgar Hucek <gimli@dark-green.com>
Subject: Re: EFI Framebuffer Documentation
References: <4EDFF88F.7090802@linux.intel.com>
In-Reply-To: <4EDFF88F.7090802@linux.intel.com>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2011 03:36 PM, Darren Hart wrote:
> Documentation/fb/efifb.txt states that "efifb is only for EFI booted
> Intel Macs." I took this to mean that CONFIG_FB_EFI may also only be for
> Intel Macs. Turns out I need CONFIG_FB_EFI for video console output on
> my Atom EFI booted development boards.
> 
> Does this mean efifb.txt needs to be updated, or are the two actually
> referring to different things?

It needs update, I believe.

	-hpa

