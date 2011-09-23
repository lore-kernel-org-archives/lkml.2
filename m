Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792Ab1IWSwf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 14:52:35 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58328 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504Ab1IWSwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 14:52:33 -0400
Message-ID: <4E7CD560.8010706@suse.cz>
Date: Fri, 23 Sep 2011 20:52:16 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110918 Thunderbird/7.0
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>, gregkh@suse.de,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com
Subject: Re: [PATCH 1/4] TTY: serial, fix locking imbalance
References: <1314818699-10873-1-git-send-email-jslaby@suse.cz> <20110922224653.GB21296@kroah.com>
In-Reply-To: <20110922224653.GB21296@kroah.com>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2011 12:46 AM, Greg KH wrote:
> On Wed, Aug 31, 2011 at 09:24:56PM +0200, Jiri Slaby wrote:
>> Commit "TTY: serial, move locking in uart_close" moved the lock, but
>> omitted to update branches which unlock the lock. Now they try to
>> unlock the lock without holding it.
>>
>> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
>> ---
>> If possible, please, merge this into the patch mentioned above (it's
>> not upstream yet).
> 
> I can't do that,

Hmm, but what is the reason for that? I mean, why do you prefer a kernel
with broken history with respect to bisection? Per definition -next
doesn't mind rebases in subtrees. Or is this already in tty-linus branch
(I cannot check now, obviously)?

> and Nobuhiro Iwamatsu sent this to me before you, so
> I'll take his version instead, if you don't mind.

No, I don't of course.

thanks,
-- 
js
suse labs
