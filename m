Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750929Ab1EIECQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 00:02:16 -0400
Received: from mta31.charter.net ([216.33.127.82]:48813 "EHLO
	mta31.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab1EIECJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 00:02:09 -0400
X-Greylist: delayed 31736 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 May 2011 00:02:08 EDT
X-Authority-Analysis: v=1.1 cv=1b2X7W/SifksZeClH/haT1SUt4udqxFGF00pZw2/jJk=
 c=1 sm=1 a=51Irx3Jbk-AA:10 a=DyMOC9dMV3IA:10 a=8nJEP1OIZ-IA:10
 a=xzrYXqw+0zwiO4gHSXHcAg==:17 a=so9t2-1jSI87Cw2gUg8A:9
 a=cCuTdpuqj1GKR6y409EA:7 a=wPNLvfGTeEIA:10 a=xzrYXqw+0zwiO4gHSXHcAg==:117
Message-ID: <4DC76739.4000302@cuw.edu>
Date: Sun, 08 May 2011 23:02:01 -0500
From: Greg Dietsche <gregory.dietsche@cuw.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110307 Icedove/3.0.11
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Alan Stern <stern@rowland.harvard.edu>, mfuzzey@gmail.com,
        tom.leiming@gmail.com, ak@linux.intel.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: fix warning in usbtest module
References: <Pine.LNX.4.44L0.1105081033140.30441-100000@netrider.rowland.org> <4DC6EB3B.8070604@cuw.edu> <20110508225847.GA12750@suse.de>
In-Reply-To: <20110508225847.GA12750@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 05/08/2011 05:58 PM, Greg KH wrote:
> Sorry, but no, use 'unsigned long' please. In the kernel, it's
> guaranteed to hold the size of a pointer, that is one of the
> requirements of Linux.
>
> And as for C99, those types don't make any sense in the kernel, only in
> userspace.  See Linus's posts on this a few years back on lkml if you
> want all of the details.
>    
Thank-you for the explanation! I will go and look up Linus's post. Since 
I'm new around here, please let me know if there are things I can do 
better and/or differently.

Thanks,
Greg

