Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130Ab1AaP41 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 10:56:27 -0500
Received: from xenotime.net ([72.52.115.56]:47433 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756121Ab1AaP40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 10:56:26 -0500
Date: Mon, 31 Jan 2011 07:56:19 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Amirali Shambayati <amirali.shambayati@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kernel compilation error
Message-Id: <20110131075619.c738c551.rdunlap@xenotime.net>
In-Reply-To: <AANLkTinDHW9BOFVi9Kux3p_swX-ZtzsravAgXQ2KVooU@mail.gmail.com>
References: <AANLkTinDHW9BOFVi9Kux3p_swX-ZtzsravAgXQ2KVooU@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Jan 2011 12:15:59 +0330 Amirali Shambayati wrote:

> Hello,
> 
> I have problem with compiling kernel. I receive this error during
> compilation process:
> /include/trace/events/kmem.h:45: undefined reference to `.L1747'
> I googled it but I didn't find any useful tip.
> 
> Anybody's help is appreciated.


Hi,
What kernel version?

Please post the kernel .config file that you are using.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
