Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758593Ab0GON3F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 09:29:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36831 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758518Ab0GON3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 09:29:03 -0400
Message-ID: <4C3F0D1B.9060403@suse.cz>
Date: Thu, 15 Jul 2010 15:28:59 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org
Subject: Re: any value in running my kernel scanning scripts before release?
References: <alpine.DEB.2.00.1007150728520.13042@lynx>
In-Reply-To: <alpine.DEB.2.00.1007150728520.13042@lynx>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2010 01:32 PM, Robert P. J. Day wrote:
> 
>   normally i wait for the merge window, then run my kernel scanning
> scripts and post results.  any interest in me doing that earlier?  i
> just did a quick test and found a number of incongruities like, for
> example:
> 
> $ grep -r "config QT2160" *
> drivers/input/keyboard/Kconfig:config QT2160
> $
> 
> $ grep -r KEYBOARD_QT2160 *
> drivers/input/keyboard/Makefile:obj-$(CONFIG_KEYBOARD_QT2160) += qt2160.o
> $

These are plain bugs, so it's IMO OK to send fixes for these at any time
before the final release. In the worst case, it will be merged after the
final release.

just my two cents,
Michal
