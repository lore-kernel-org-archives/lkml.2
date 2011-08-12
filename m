Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab1HLRTd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 13:19:33 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:58758 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751476Ab1HLRTb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 13:19:31 -0400
Date: Fri, 12 Aug 2011 10:19:28 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Jonathan =?ISO-8859-1?Q?Neusch=E4fer?= <j.neuschaefer@gmx.net>
Cc: linux-kernel@vger.kernel.org, Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH] UserModeLinux-HOWTO.txt: remove ^H characters
Message-Id: <20110812101928.f34da400.rdunlap@xenotime.net>
In-Reply-To: <1313108903-7351-1-git-send-email-j.neuschaefer@gmx.net>
References: <1313108903-7351-1-git-send-email-j.neuschaefer@gmx.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Aug 2011 02:28:23 +0200 Jonathan Neuschäfer wrote:

> If you can't read this patch, please run:
> 
> 	sed -i -e "s/[^\o10]\o10//g" \
> 		Documentation/virtual/uml/UserModeLinux-HOWTO.txt
> 
> Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
> ---
>  Documentation/virtual/uml/UserModeLinux-HOWTO.txt |  530 ++++++++++----------
>  1 files changed, 265 insertions(+), 265 deletions(-)

I like the patch, although the text file seems to be quite old and it
appears to be a generated file (from where?).

Acked-by: Randy Dunlap <rdunlap@xenotime.net>

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
