Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612Ab2BGFsO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 00:48:14 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:49383 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab2BGFsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 00:48:13 -0500
Message-ID: <4F30BB0B.5060203@gmail.com>
Date: Tue, 07 Feb 2012 00:47:55 -0500
From: Richard Farina <sidhayn@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.2; en-US; rv:1.8.1.6) Gecko/20070728 Thunderbird/2.0.0.6 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: sarah.a.sharp@linux.intel.com, Larry Finger <Larry.Finger@lwfinger.net>,
        andiry.xu@amd.com
CC: linux-kernel@vger.kernel.org
Subject: Re: Question about error from xhci-hcd
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I apologize but I am having the same issue reported in this thread in
December

[ 5077.573181] xhci_hcd 0000:0a:00.0: ERROR no room on ep ring

I saw no resolution on this issue so I figured I'd step up and see if
you needed an active tester who could reproduce the issue.

I am running Gentoo with a 3.2.2 kernel.  I am able to run any kernel
version you need, including random git trees and custom patches.  If you
have not solved this yet, please allow me to be your test monkey. If you
have solved this already then sorry for harming the signal to noise
ratio, I could not a find a later message then the one below.

Thanks,
Rick

On 12/28/2011 10:30 PM, Andiry Xu wrote: 
> 
> That's the error I want to see, but I didn't find it in the dmesg you 
> posted. is it wrapped? 
> 
> Anyway, please post the full dmesg with no room on ring error and the 
> dump of the ep ring and event ring (so the xhci_debug_ring() is 
> triggered in the patch), so we can see if the ring is mangled or there 
> is just too many transfers. 
> 
> Another thing you can try is the andiry-ring-expansion branch on Sarah's 
> xhci git tree, check if there is still no room on ring error. 

No, the ring is not wrapped. I seems that my anti-spam mechanism kicked
in too 
soon. or the run stopped too soon. 

I'll have the OP do another run and see if we can get the right
information. 

Larry 
--
