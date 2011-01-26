Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292Ab1AZOaB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 09:30:01 -0500
Received: from smarthost01.mail.zen.net.uk ([212.23.3.140]:43072 "EHLO
	smarthost01.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752267Ab1AZOaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 09:30:00 -0500
Message-ID: <4D402FDE.2050407@cyconix.com>
Date: Wed, 26 Jan 2011 14:29:50 +0000
From: Evan Lavelle <sa212+lkml@cyconix.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Kernel deferring driver 'close' call: workaround?
References: <4D401824.6090109@cyconix.com> <20110126131703.3033ad87@lxorguk.ukuu.org.uk>
In-Reply-To: <20110126131703.3033ad87@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-Smarthost01-IP: [82.70.243.134]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/01/2011 13:17, Alan Cox wrote:

> I imagine the user has a bug in their app. The close method is called on
> the final close of the handle. That means if for example you do something
> like fork off a child process and forget to close the handle then it
> won't actually close down until the final user closes it.

That was my first reaction, but the strace output only shows an open and 
close of two shared libs, open and close for this board, some mmaps from 
the driver, and the basic brk/fstat/etc stuff. Unfortunately, I haven't 
got the app source, or even the board... :(

-Evan

