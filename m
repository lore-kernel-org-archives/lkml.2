Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863Ab1BXSlc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 13:41:32 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48074 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090Ab1BXSla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 13:41:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=QqUl5RYDUNNfaYcMa2kMk4nsrAJ6vpn+W5l555cLW8DztPq1cw6RBYn5RZuDnn0ITu
         CPwEbahZN5jCNBbsB98yGMqJY9k730wZBPgK67JWk6jmcpQ3TtyQW49UkzK24FcWdQDA
         NIaOUKQJOCeHaaRP8ijL9xJPpP29HjdUD9XhI=
Message-ID: <4D66A647.7050502@gmail.com>
Date: Thu, 24 Feb 2011 19:41:11 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
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
> 
> What about if you leave async enabled for all the USB devices _except_ 
> usb[1-N]?

It died right now.

So I booted with no_console_suspend.

thanks,
-- 
js
