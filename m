Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab0EKA1k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 20:27:40 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55115 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042Ab0EKA1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 20:27:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Pk1+66GfjBidKuz4lNtwiuyJN+1rMP40u+H8xFlrPTC2EQ0KZ6q5VXgp9LUNco4vDe
         NJMahr5o9eJFslCkpY7GKcNP7Znq7hi38xwgUjrw35uEx26+zn3zx7K6AmzoVxnmM9K4
         AUgf5tCEJ26BO+gQm5Nz59UFFIbTYlYJGPIQA=
Message-ID: <4BE8A477.9080703@gmail.com>
Date: Mon, 10 May 2010 18:27:35 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Donald Allen <donaldcallen@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: tickless scheduling
References: <AANLkTin6D2GP0yJJbPYGH1AcAM9-g219rAxSyW_ZlrXV@mail.gmail.com>
In-Reply-To: <AANLkTin6D2GP0yJJbPYGH1AcAM9-g219rAxSyW_ZlrXV@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2010 06:18 PM, Donald Allen wrote:
> 1. Network file transfers and fscks stop on Toshiba netbook unless
> system receives external events
> 2. I have a new Toshiba NB305 on which I installed the beta release of
> Slackware 13.1, which provides a 2.6.33.3 kernel with the tickless
> option enabled. With this machine on my ethernet, I attempted to rsync
> my home directory to it, about 9 Gb, from a workstation that is my
> primary system (running Slackware 13). The transfer proceeded normally
> for awhile and then stopped, which I could see in the xterm on the
> workstation. I went to the netbook to see what was going on there and
> when I began typing, the transfer resumed. I ran 'top' on the netbook
> and it would freeze after a few updates, coinciding with the file
> transfer pausing again. Typing would get things moving. At another
> point, I tested pm-suspend on the netbook. Suspending worked, but
> awakening did not, so I had to power-cycle the machine. I use ext2 for
> reasons which I won't attempt to justify here, so when the machine
> came back up, it fsck'ed the root filesystem. Here again I saw things
> grind to a halt -- the progress meter stopped and the there was no
> disk activity. But if I moved my finger on the touchpad, things would
> get moving again. The only way to get the fsck to complete was to
> constantly be tickling the touchpad. I corresponded with Patrick
> Volkerding, telling him I suspected a scheduling problem and he
> informed me that the 13.1 kernel had tickless enabled, unlike 13. So I
> built a 2.6.33.3 kernel (from the Slackware-supplied kernel sources)
> with tickless disabled. With that kernel running, I power-cycled the
> machine to force a fsck of the root filesystem. This one proceeded to
> completion normally -- no external stimuli needed.
> 3. Tickless, scheduler
> 4. 2.6.33.3
> 7.1 ver_linux output attached
> 7.2 /proc/cpuinfo attached
> 7.3 /proc/modules attached
> 7.4 /proc/ioports, /proc/iomem attached
> 7.5 lspci attached
> 7.6 /proc/scsi/scsi attached

Can you post dmesg output from bootup?
