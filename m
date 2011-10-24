Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203Ab1JXWVj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 18:21:39 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:60553 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094Ab1JXWVh (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Mon, 24 Oct 2011 18:21:37 -0400
Subject: Re: [PATCH] acer-wmi: blacklist Thinkpad edge E520
From: joeyli <jlee@suse.com>
To: Ike Panhc <ike.pan@canonical.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>, Joey Lee <jlee@novell.com>
In-Reply-To: <4E9CE262.60601@canonical.com>
References: <1318488718-4744-1-git-send-email-ike.pan@canonical.com>
	 <1318523759.1913.68.camel@linux-s257.site>  <4E97A307.20208@canonical.com>
	 <1318902491.1913.348.camel@linux-s257.site>  <4E9CE262.60601@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 Oct 2011 06:20:31 +0800
Message-ID: <1319494831.17773.153.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ike, 

於 二，2011-10-18 於 10:20 +0800，Ike Panhc 提到：
> Hi Joey,
> 
> On 10/18/2011 09:48 AM, joeyli wrote:
> > Hi Ike, 
> > 
> > Could you please attached on the "rfkill list" output when press Fn key?
> > Then we can check the rfkill status change.
> 
> The output of rfkill list is at
>   https://launchpadlibrarian.net/78485925/RfKill.txt
> 
> .. and bug reporter tells me that he can not unblock wireless.
>   https://bugs.launchpad.net/ubuntu/+source/linux/+bug/836865/comments/0
> 
> > 
> > And, 
> > Thinkpad E520 have AMW0 method and I thought acer-wmi query wrong EC
> > register address so your acer-wireless was always soft-blocked.
> > 
> > Does it possible kindly help me to find out which register on E520 is
> > mapping to wireless status? Please reference to Carlos's acer_ec.pl
> > tool:
> > 
> > http://code.google.com/p/aceracpi/wiki/EmbeddedController
> > 
> > Simple use:
> >         watch -n 1 perl acer_ec.pl regs
> > 
> > Then press your wireless Fn key to monitor which register changed when
> > you press Fn key:
> > 
> > e.g. the register at row B0 and column 0A is register 0xBA (0x is used
> > to indicate this is a hexadecimal number).
> > 
> > There maybe have other EC register changing when you press key, please
> > do a couple of times and make sure you find out the right one.
> > 
> > If we are lucky, we can find out one EC register mapping to your
> > wireless state.
> 
> I've asked bug reporter to do so. Unfortunately nothing useful found.
> 
> Please refer to the link below:
>   https://bugs.launchpad.net/ubuntu/+source/linux/+bug/836865/comments/13
>   https://bugs.launchpad.net/ubuntu/+source/linux/+bug/836865/comments/14
> 
> The full discussion is at
>   https://bugs.launchpad.net/ubuntu/+source/linux/+bug/836865
> 

Bad! 

I also didn't see useful things from DSDT, looks like the control
doesn't through EC.

Let's add this device to blacklist!


Thank's
Joey Lee


