Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab0FNGw1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 02:52:27 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65079 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755102Ab0FNGw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 02:52:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eWoAeJ0ffTfCEpmKmfo94w5UeMZZlyMXpzyPuwpALK4tX//+iot6kiy7vlI9KkbCT1
         nA4fTuzZpcx4Yn6WOdZXwbuk2JLpPaxmmpjngwlrlYU8XtDkTxPHGH9mm3+ulvedXLwa
         q9RZV7YzPZOKfyTQERmpZAPmsQh97gaiVI/9M=
Date: Mon, 14 Jun 2010 09:52:21 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Mark Hills <mark@pogo.org.uk>
Cc: linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
       Michal Marek <mmarek@suse.cz>
Subject: Re: Appending '+' to version, since 2.6.35-rc2
Message-ID: <20100614065221.GB3999@x200>
References: <alpine.NEB.2.01.1006131729430.2991@jrf.vwaro.pbz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.NEB.2.01.1006131729430.2991@jrf.vwaro.pbz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 13, 2010 at 08:01:26PM +0100, Mark Hills wrote:
> Commit 85a256d adds a new feature:
> 
>   [...] When CONFIG_LOCALVERSION_AUTO is not enabled, a `+' is appended
>   to the kernel version to represent that the kernel has been revised
>   since the last release unless "make LOCALVERSION=" was used to uniquely
>   identify the build.
> 
> I'm finding this inconvenient for 'casual' kernel development.
> 
> For example, my usual workflow goes something like:
> 
> 1) find something I suspect is a bug
> 2) upgrade to the latest stable or -rc kernel, to confirm
> 3) experiment with patch to fix it
> 
> Since 2.6.35-rc2, going from step 2 to 3 causes the version of the kernel 
> to change: forcing time-consuming rebuilds,

init/version.c
kernel/configs.c
+ whatever patch has changed
+ vmlinux 2 or 3 times

That's not time consuming.

> installing modules, and manual 
> changes associated with a new version number; eg. updating the lilo/grub 
> config, or the distribution's initrd.
