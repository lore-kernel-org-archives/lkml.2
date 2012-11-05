Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741Ab2KEKNe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 05:13:34 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:36444 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab2KEKNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 05:13:32 -0500
Date: Mon, 5 Nov 2012 11:13:31 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, John Stultz <john.stultz@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Janne Boman <janne.m.boman@gmail.com>,
        Heinz Wiesinger <HMWiesinger@gmx.at>, rtc-linux@googlegroups.com
Subject: Re: [regression] Re: [ 049/149] rtc: Disable the alarm in the
 hardware (v2)
Message-ID: <20121105101331.GA24688@kroah.com>
References: <20120330195823.GA31857@kroah.com>
 <20120330194844.399828645@linuxfoundation.org>
 <20121105091118.GA12721@elie.Belkin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121105091118.GA12721@elie.Belkin>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2012 at 01:11:18AM -0800, Jonathan Nieder wrote:
> Hi,
> 
> In March, Greg KH wrote:
> 
> > 3.2-stable review patch.  If anyone has any objections, please let me know.
> 
> Sorry, I'm a little late.  This seems to be causing spurious wakeups
> after shutdown on some systems just like v1 did. :/
> 
> Janne Boman reports[1], using an HP EliteBook 8530w:
> 
> | I'm unable to shutdown my system via normal means. The system
> | completes the shutdown process, all hardware lights are off, but then
> | somehow it restarts.
> 
> Based on a quick web search, Heinz Wiesinger, using the same model,
> ran into the same problem and bisected it to this patch:
> 
>   https://bugzilla.kernel.org/show_bug.cgi?id=44261
> 
> Janne confirmed the same by testing kernels closely based on 3.2.13
> and 3.2.14 --- 3.2.13 shut down fine, while on 3.2.14 "shutdown -h
> now" behaved roughly speaking like "reboot".  A kernel close to 3.6.4
> was also affected.

So is 3.6.6 still and issue?  How about 3.7-rc4?  3.4.18?  Figuring out
if this is still an issue in Linus's tree would be the best thing to do
first.

thanks,

greg k-h
