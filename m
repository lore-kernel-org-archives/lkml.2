Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933742Ab0FRPpO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 11:45:14 -0400
Received: from xenotime.net ([72.52.115.56]:59496 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933708Ab0FRPpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 11:45:10 -0400
Date: Fri, 18 Jun 2010 08:45:07 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Alan Ott <alan@signal11.us>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] HID: Documentation for hidraw
Message-Id: <20100618084507.3dcba19a.rdunlap@xenotime.net>
In-Reply-To: <1276832283-12084-1-git-send-email-alan@signal11.us>
References: <1276832283-12084-1-git-send-email-alan@signal11.us>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jun 2010 23:38:03 -0400 Alan Ott wrote:

> Documenation for the hidraw driver.
> 
> Signed-off-by: Alan Ott <alan@signal11.us>
> ---
> 
>  Documentation/hidraw.txt |  283 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 283 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/hidraw.txt

In the new sub-directory, please split the example/test program into a separate
source file and add a Makefile so that it will build.

There are similar Makefiles in many other Documentation/ sub-directories.

thanks.
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
