Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998Ab2BGPAL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 10:00:11 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:40159 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206Ab2BGPAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 10:00:09 -0500
Message-ID: <4F313C68.2070408@gmail.com>
Date: Tue, 07 Feb 2012 09:59:52 -0500
From: Richard Farina <sidhayn@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.2; en-US; rv:1.8.1.6) Gecko/20070728 Thunderbird/2.0.0.6 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: sarah.a.sharp@linux.intel.com, andiry.xu@amd.com,
        linux-kernel@vger.kernel.org
Subject: Re: Question about error from xhci-hcd
References: <4F30BB0B.5060203@gmail.com> <4F31275A.8000502@lwfinger.net>
In-Reply-To: <4F31275A.8000502@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/12 08:30, Larry Finger wrote:
> On 02/06/2012 11:47 PM, Richard Farina wrote:
>> I apologize but I am having the same issue reported in this thread in
>> December
>>
>> [ 5077.573181] xhci_hcd 0000:0a:00.0: ERROR no room on ep ring
>>
>> I saw no resolution on this issue so I figured I'd step up and see if
>> you needed an active tester who could reproduce the issue.
>>
>> I am running Gentoo with a 3.2.2 kernel.  I am able to run any kernel
>> version you need, including random git trees and custom patches.  If you
>> have not solved this yet, please allow me to be your test monkey. If you
>> have solved this already then sorry for harming the signal to noise
>> ratio, I could not a find a later message then the one below.
>
> Are the "no room" messages triggered by rtl8192cu, or some other driver?
>
rtl8187 and rt2800usb both seem to reliably trigger that message on my
system. And when I say reliably I mean by the time I noticed I had a
1.5GB /var/log/messages.  Fortunately I have several usb2 ports in
addition to the affected usb3 ports. :-)

-Rick
> Larry
>
>
>

