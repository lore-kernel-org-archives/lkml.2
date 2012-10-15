Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab2JONf1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 09:35:27 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:62866 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163Ab2JONf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 09:35:26 -0400
MIME-Version: 1.0
In-Reply-To: <20120904212529.GA6830@kroah.com>
References: <1346074458-2659-1-git-send-email-chenbdchenbd@gmail.com>
	<503F6C52.6030100@suse.cz>
	<20120904212529.GA6830@kroah.com>
Date: Mon, 15 Oct 2012 21:35:25 +0800
Message-ID: <CAEAuANM8cfv+s5s1sqas11FZWYEcGUwxUQ4qq74_swKNM-uCrA@mail.gmail.com>
Subject: Re: [PATCH] staging:fixed code to fit tty_driver's kref filed fixed
 code to fit tty_driver's kref filed for drivers/staging/net/pc300_tty.c
From: Baodong Chen <chenbdchenbd@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, devel@driverdev.osuosl.org,
        davem@davemloft.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sorry for my mistake, i should do more home work on code!!

On Wed, Sep 5, 2012 at 5:25 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Thu, Aug 30, 2012 at 03:36:18PM +0200, Jiri Slaby wrote:
>> On 08/27/2012 03:34 PM, Baodong Chen wrote:
>>
>> Sorry, I do not get this change. You should not touch tty_driver.kref at
>> all.
>
> Yeah, that's not ok, it's now dropped from my patch queue.
>
> greg k-h
