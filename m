Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208Ab0DISAJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 14:00:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43709 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755009Ab0DISAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 14:00:06 -0400
Date: Fri, 9 Apr 2010 10:22:50 -0700
From: Greg KH <gregkh@suse.de>
To: Gunnar Gudvardarson <gunni@wave.is>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: asus_oled: asus_oled.c removed an unnessecary
 space, making it checkpatch clean
Message-ID: <20100409172250.GA15900@suse.de>
References: <1270818069-3400-1-git-send-email-gunni@wave.is>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1270818069-3400-1-git-send-email-gunni@wave.is>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 09, 2010 at 01:01:09PM +0000, Gunnar Gudvardarson wrote:
> This is the first linux kernel patch i have ever made, i don't even
> know the C programming language except reading the syntax (basic)

Then I would strongly encourage you to either learn it, or not modify
the code.

> It didn't compile on my machine due to invalid configuration of something
> on my machine, because i have not yet learned how to configure the compiler.

Especially as you were not able to build test the patch, which is a
basic requirement for submitting code changes.

Try reading the kernel file, Documentation/HOWTO for pointers on how to
find information to learn the C language, and to learn how to build a
kernel on your own.

best of luck,

greg k-h
