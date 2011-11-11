Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758193Ab1KKUq7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 15:46:59 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34845 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab1KKUq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 15:46:56 -0500
Message-ID: <4EBD89A8.7070503@gmail.com>
Date: Fri, 11 Nov 2011 17:46:32 -0300
From: "Tomas M." <tmezzadra@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20111108 Thunderbird/8.0
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: deepthi@linux.vnet.ibm.com, g.trinabh@gmail.com, j-pihet@ti.com,
        khilman@ti.com, arjan@linux.intel.com, len.brown@intel.com
Subject: Re: [bisected][bug] commit e978aa7d7d57d04eb5f88 breaks suspend on
 laptop.
References: <4EBD46DF.6060507@gmail.com>
In-Reply-To: <4EBD46DF.6060507@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Follow up.


reverted this and the following 3 commits from this patch set and the 
problem is gone.

46bcfad7a819bd17ac4e831b04405152d59784ab
4202735e8ab6ecfb0381631a0d0b58fefe0bd4e2
b25edc42bfb9602f0503474b2c94701d5536ce60
e978aa7d7d57d04eb5f88a7507c4fb98577def77

they all seem to be related.


On 11/11/2011 01:01 PM, Tomas M. wrote:
> bisected to e978aa7d7d57d04eb5f88a7507c4fb98577def77
>
> cannot revert the commit cleanly to further test
>
> attaching pm-suspend log.  /proc/cpuinfo and lspci -vvnn just in case. 
> If more info is needed, please let me know.
>
> thanks!
> ----
> when trying to suspend... the system locks right before suspending.
> sysrq keys  will not work at this point
>
>
> please include me in the CC since im not subscribed to the list.
>
> i CCed everyone mentioned in the commit. if you were CCed by mystake, 
> sorry.
