Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751720Ab1GUJ2K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 05:28:10 -0400
Received: from mail.bbaw.de ([194.95.188.6]:46218 "EHLO mail.bbaw.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834Ab1GUJ2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 05:28:07 -0400
Date: Thu, 21 Jul 2011 11:28:04 +0200
From: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
To: Michael Brade <brade@informatik.uni-muenchen.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.39, 3.0.0-rc7+: complete system freeze with rsync on big
 directory
Message-Id: <20110721112804.7aa0043d.taeuber@bbaw.de>
In-Reply-To: <201107211119.15496.brade@informatik.uni-muenchen.de>
References: <201107211119.15496.brade@informatik.uni-muenchen.de>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-AntiVirus: checked by Avira MailGate (version: 2.1.4-7; AVE: 7.9.6.18; VDF: 7.11.12.27; host: mailhub); id=27012-GmO9v5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

I'm just curious, because I have troubles with storage IO too.

Am Thu, 21 Jul 2011 11:19:15 +0200
Michael Brade <brade@informatik.uni-muenchen.de> schrieb:
> Hi,
> 
> this is perfectly reproducible: with vanilla 2.6.39.x and 3.0.0 from 
> yesterday's git my system completely freezes after a minute or so when I do
> 
>    rsync -cavSH -n /source/ /dest/
> 
> Watching htop, it freezes only after the caches are full but not
> immediately when the caches are full. No Alt-SysRq-magic is working
> anymore, nothing responds at all after the freeze. This is on tty1, no X
> server running.
> 
> Note the -n which means dry run. I also mounted both directories read-only,
> so it's not the write commands. I am using XFS on both directories, one is 
> mounted with iscsi, the other is local and encrypted with loop-aes. The 
> directory size is >20 GB, 4000-6000 files. I first noticed it when a 
> cp -a /source /dest froze the system.
> 
> When I go back to 2.6.37.6 it works fine. I didn't try 2.6.38 yet.
> 
> I am running this on a Dell Vostro, amd64, 6 GB RAM, 8x Intel Core i7 CPU Q 
> 740 @ 1.73GHz.
> 
> Any ideas how to debug this despite the freeze? Do you need my kernel
> config? Do you need any other info? Please CC me.

Could you try to capture the log via serial console?
(linux/Documentation/serial-console.txt)

What kind of disks/controller/driver do you use?



Lars
