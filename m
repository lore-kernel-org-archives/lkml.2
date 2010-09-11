Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751387Ab0IKSAx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 14:00:53 -0400
Received: from xenotime.net ([72.52.115.56]:39514 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751050Ab0IKSAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 14:00:52 -0400
Date: Sat, 11 Sep 2010 11:00:50 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: git crapps out with {kernel_version}/usr/include
Message-Id: <20100911110050.1c6f275c.rdunlap@xenotime.net>
In-Reply-To: <4C8BB4F3.3040907@gmail.com>
References: <4C8BB4F3.3040907@gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Sep 2010 09:57:23 -0700 Justin P. Mattock wrote:

> finishing up with looking at broken web addresses Im noticing that
> usr/include/* seems to not work with git i.e. theres a couple of broken 
> addresses in there after changing them, then using git commit -s -a
> gives me the "nothing to commit message"..
> why is this?

usr/include/* is all generated files from elsewhere in the kernel tree,
so you should just change the original files, not the generated ones.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
