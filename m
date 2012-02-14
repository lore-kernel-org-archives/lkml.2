Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758640Ab2BNBit (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 20:38:49 -0500
Received: from hades.mikemestnik.net ([184.106.158.151]:36574 "EHLO
	hades.mikemestnik.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578Ab2BNBis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 20:38:48 -0500
Message-ID: <4F39BB25.5010404@mikemestnik.net>
Date: Mon, 13 Feb 2012 19:38:45 -0600
From: Mike Mestnik <cheako@mikemestnik.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Just a failed drive. Was: Sysreq during system hang where ssh/screen
 still accessible.
References: <4F3956B3.1060604@mikemestnik.net>
In-Reply-To: <4F3956B3.1060604@mikemestnik.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's kind of odd that these are the symptoms of a failing disc.  I think 
perhaps syslog and others should be made to not swap??

This may also have something to do with my zram hack that re-mounts the 
zram swaps every 5min to flush them to disk.

On 02/13/2012 12:30 PM, Mike Mestnik wrote:
> Hello,
>   I have an unusual hang:
> The box is responding to monitor wakeup key presses and putting the 
> display to sleep after idle, however the screen is always blank.
>
> From the network side a previously started root ssh screen session can 
> create more views,but the shell never starts, neither does ls from an 
> existing shell.
>
> I've configured remote logging and there is noting in any of the logs 
> to indicate a problem, smart-tools is installed.
>
> The remote log(over SCTP) is still connected and the IRC client is 
> still connected.
>
> Kernel messages are being logged, last msg from apparmor about empathy.
>
> Key presses wake up monitor, but sysreq-s is not logging anything.
>
> No further ssh shells able to check, but I don't think that dmesg 
> would even start.
>
> However ssh/screen is still responsive to create new views and switch 
> views, but the shell never starts.
>
> Feb 12 17:33:33: The only error is smatd: Prefailure: Spin_Up_Time (3) 
> changed to: 197
> Feb 13 12:54 AM an email http://pastebin.com/A8srcY7v
> However nothing in the _remote_ log around 1AM/12:54.
>
> Any thoughts?
> linux-image-3.2.0-15-generic-pae
> System specs.
> http://pastebin.com/35NwE0G1
>

