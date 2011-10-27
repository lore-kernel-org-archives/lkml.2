Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab1J0NHX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 09:07:23 -0400
Received: from 95-31-19-74.broadband.corbina.ru ([95.31.19.74]:44470 "EHLO
	dnet.ilyx.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072Ab1J0NHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 09:07:22 -0400
Message-ID: <4EA95788.90808@ilyx.ru>
Date: Thu, 27 Oct 2011 17:07:20 +0400
From: Ilya Zykov <ilya@ilyx.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110929 Iceape/2.0.11
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] TTY: pty, fix pty counting in "/proc/sys/kernel/pty/nr"
References: <4EA928F3.7010204@ilyx.ru> <20111027123742.GB7910@kroah.com>
In-Reply-To: <20111027123742.GB7910@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:

> On Thu, Oct 27, 2011 at 01:48:35PM +0400, Ilya Zykov wrote:
>> Regression for commit: 24d406a6bf736f7aebdc8fa0f0ec86e0890c6d24
>> Commit: 24d406a6b accepted in Linux 3.1.
>> Disscussed on linux-kernel@vger.kernel.org "subject: [PATCH] TTY: pty, fix pty counting"
>> and not accepted.
>> Although, I think it's clear.
> 
> Ilya, is there some reason you are ignoring the tty maintainer and
> sending these to Linus directly?  These patches need to be tested in
> linux-next, so at the earliest, they can be merged into Linus's tree for
> 3.3, they are NOT 3.2 material, especially given that they are not even
> accepted by the current tty developers.
> 
> So please work with us, and don't try to circumvent the existing
> process, it is not the way we work here.
> 
> Especially as this specific patch was already rejected, for very good
> reasons, why are you ignoring those reasons?
> 
> thanks,
> 
> greg k-h
> 


OK, I understand you rules. 
But I don't understand, what for, you accept patch(commit: 24d406a6bf736f7aebdc8fa0f0ec86e0890c6d24), 
where "pty" call tty_driver_remove_tty(), only for invoke its own route(pty_unix98_remove).

Thank you.
Ilya.


