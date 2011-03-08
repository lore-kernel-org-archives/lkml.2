Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674Ab1CHJN5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 04:13:57 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53641 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab1CHJNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 04:13:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=pjNpIeTSByR/3zRU1aw8XWiiFUR/kLTkfg8R5dEDIwLVucVzHWe7W0ujslFdA8gt1U
         Gf4+PhDAEhY8LZE/H1QR1D9BPLI4UuvS2uutFTtjtqlFWEQRDYHdLQvaU6bz/Kel/0xJ
         ap72jpbf1xu+cWrnkZ3YQekC4BCD6YtRv9hbY=
Message-ID: <4D75F34B.5010409@gmail.com>
Date: Tue, 08 Mar 2011 10:13:47 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: "Rafael J. Wysocki" <rjw@suse.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] Resume hangs [was: mmotm 2010-12-02-16-34 uploaded]
References: <Pine.LNX.4.44L0.1102221029100.1968-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1102221029100.1968-100000@iolanthe.rowland.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2011 04:36 PM, Alan Stern wrote:
> By the way, are you booting with no_console_suspend?  And do you do 
> "echo 8 >/proc/sys/kernel/printk" (or equivalently, Alt-SysRq-8) before 
> suspending?

Unfortunately there are no messages at all.

Rafael, this is a Factory with intel gfx (modesetting). Do pm-utils
switch a console in such case? And if yes, to which one?

thanks,
-- 
js
