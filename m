Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002Ab2B2UJ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 15:09:56 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56914 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754683Ab2B2UJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 15:09:55 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.219.130 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
Date: Wed, 29 Feb 2012 12:09:10 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: =?utf-8?B?UGF3ZcWC?= Sikora <pawel.sikora@agmk.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [3.2.2] oom + no-killable-processes.
Message-ID: <20120229200910.GB31348@kroah.com>
References: <3905756.9FRF7uBtcE@vmx>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3905756.9FRF7uBtcE@vmx>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 08:28:23PM +0100, Paweł Sikora wrote:
> Hi all,
> 
> i've found on my 8-core opterons following oops (oom+nokillable): http://imgbin.org/index.php?page=image&id=6945
> usualy the kernel just kills processes from userspace but this time something has gone wrong...
> sysrq was dead, so no more stacktraces :/

Is this something new with 3.2.2?  If so, can you bisect it down to the
patch that causes the problem?  Does 3.2.0 have this issue?  3.2.8?

thanks,

greg k-h
