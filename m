Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab1HDL17 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 07:27:59 -0400
Received: from centrinvest.ru ([94.25.115.130]:48348 "EHLO centrinvest.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752727Ab1HDL16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 07:27:58 -0400
X-Greylist: delayed 1858 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Aug 2011 07:27:58 EDT
Date: Thu, 4 Aug 2011 14:56:57 +0400
From: Andrey Panin <pazke@centrinvest.ru>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: How to access serial port that is set in BIOS as OS Controlled
Message-ID: <20110804105657.GA27681@centrinvest.ru>
Mail-Followup-To: Jeff Chua <jeff.chua.linux@gmail.com>,
	lkml <linux-kernel@vger.kernel.org>
References: <CAAJw_ZvnUPs5wD6hU059GcKRkyeNn7Y36fk9nNjNFJ6kNmL0uw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAJw_ZvnUPs5wD6hU059GcKRkyeNn7Y36fk9nNjNFJ6kNmL0uw@mail.gmail.com>
X-Uname: Linux 2.6.26-2-amd64 x86_64
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Anti-Virus: kav4lms: continue
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 209, 07 28, 2011 at 01:43:11PM +0800, Jeff Chua wrote:
> I'm trying to access the serial port ttyS2 that is set in the BIOS as
> "OS Controlled" without much success. If it's set it to "Always
> Enabled",  I can access the serial port.
> 
> This is on the Intermec CV60, and ttyS2 is the touchscreen port.
> 
> # setserial /dev/ttyS2
> /dev/ttyS2, UART: 16550A, Port: 0x03e8, IRQ: 6
> 
> 
> If I set the BIOS to "OS Controlled", I can't access the serial port
> no matter what parameter I pass to the setserial. The factory default
> is "OS Controlled", and Window XP can detect and access the port.
> There will be hundreds of CV60 to get into the BIOS to set it one by
> one. If there's a way to access the port in linux, it'll be great!

Does lspnp show this port in "OS Controlled" mode ?
