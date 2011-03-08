Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559Ab1CHUbO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 15:31:14 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44748 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755628Ab1CHUbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 15:31:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=lqaYGBp+yCSSxSlN442iNx8m+p2y6arvzhYMSRm2k5VFw3pzLMyfrtyqKoRwxXiuCb
         QkH/UnymdiDqzCflLLPiyanCl/Jtx3VrWMIBibzurniiEYWmGWr3LfDidO3bbL7N40G8
         MG02ZRdwHlqNKhbOgg1uzSO5l3dcocRZmtdmw=
Message-ID: <4D76920A.8070605@gmail.com>
Date: Tue, 08 Mar 2011 21:31:06 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@suse.com>
CC: Alan Stern <stern@rowland.harvard.edu>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] Resume hangs [was: mmotm 2010-12-02-16-34 uploaded]
References: <Pine.LNX.4.44L0.1102221029100.1968-100000@iolanthe.rowland.org> <4D75F34B.5010409@gmail.com> <201103082025.38559.rjw@suse.com>
In-Reply-To: <201103082025.38559.rjw@suse.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2011 08:25 PM, Rafael J. Wysocki wrote:
> On Tuesday, March 08, 2011, Jiri Slaby wrote:
>> On 02/22/2011 04:36 PM, Alan Stern wrote:
>>> By the way, are you booting with no_console_suspend?  And do you do 
>>> "echo 8 >/proc/sys/kernel/printk" (or equivalently, Alt-SysRq-8) before 
>>> suspending?
>>
>> Unfortunately there are no messages at all.
>>
>> Rafael, this is a Factory with intel gfx (modesetting). Do pm-utils
>> switch a console in such case? And if yes, to which one?
> 
> pm-utils don't, but s2ram does, I'm not sure from the top of my head to
> which one, though.
> 
> If you use a KMS driver (I get you do), please just "chmod a-x /usr/sbin/s2ram".

Yeah, I meant kernel modesetting, of course. Sorry for the confusion.

I don't have /usr/sbin/s2ram. So I commented the --quirk-no-chvt thing
in a pm-utils script.

thanks,
-- 
js
