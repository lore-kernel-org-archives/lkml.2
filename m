Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932597Ab1KIJOM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 04:14:12 -0500
Received: from h5.dl5rb.org.uk ([81.2.74.5]:37965 "EHLO linux-mips.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932236Ab1KIJOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 04:14:09 -0500
Date: Wed, 9 Nov 2011 09:13:55 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: "Gleb O. Raiko" <raiko@niisi.msk.ru>
Cc: Al Cooper <alcooperx@gmail.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MIPS: Kernel hangs occasionally during boot.
Message-ID: <20111109091355.GB5513@linux-mips.org>
References: <y>
 <1320764341-4275-1-git-send-email-alcooperx@gmail.com>
 <20111108175532.GA15493@linux-mips.org>
 <4EBA2E65.3010009@niisi.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EBA2E65.3010009@niisi.msk.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 09, 2011 at 11:40:21AM +0400, Gleb O. Raiko wrote:

> >Author: Al Cooper <alcooperx@gmail.com> Tue Nov 8 09:59:01 2011 -0500
> >Comitter: Ralf Baechle <ralf@linux-mips.org> Tue Nov 8 16:52:51 2011 +0000
> >Commit: 9121470d99c029493bd55daa11607b398fe9aea3
> >Gitweb: http://git.linux-mips.org/g/linux/9121470d
> Could you fix those links, it's broken after you moved git repo in?

Future emails will use URLs that look like

   http://git.linux-mips.org/g/ralf/linux/9121470d

with the full repository path sans the .git suffix.  There also is a
compat hack to keep the URLs from a few thousand old commit mails working.

Thanks for reporting!

  Ralf
