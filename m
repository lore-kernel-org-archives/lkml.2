Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445Ab2BYDR6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 22:17:58 -0500
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:32800 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751284Ab2BYDR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 22:17:57 -0500
Date: Fri, 24 Feb 2012 19:17:56 -0800 (PST)
From: Andrei Warkentin <awarkentin@vmware.com>
To: linux-kernel@vger.kernel.org
Cc: jason wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net
Message-ID: <1178799454.1554025.1330139876332.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
In-Reply-To: <1329530836-23958-2-git-send-email-andreiw@vmware.com>
Subject: Re: [PATCH 1/2] KDB: Make LINES an internal variable.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.113.60.13]
X-Mailer: Zimbra 7.1.3_GA_3374 (ZimbraWebClient - FF3.0 (Linux)/7.1.3_GA_3346)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

----- Original Message -----
> From: "Andrei Warkentin" <andreiw@vmware.com>
> To: kgdb-bugreport@lists.sourceforge.net
> Cc: linux-kernel@vger.kernel.org, "jason wessel" <jason.wessel@windriver.com>, andreiw@vmware.com
> Sent: Friday, February 17, 2012 9:07:15 PM
> Subject: [PATCH 1/2] KDB: Make LINES an internal variable.
> 
> 1) If you run 'dumpall', LINES will remain set to
>    10000, and you might wonder why dmesg now doesn't
>    page.
> 2) If you run any command that sets LINES, you will
>    eventually exhaust the heap.
> 
> To address (1), you can save and restore across
> calls to "defcmd" commands, which might contain
> "set LINES". This becomes awkward with keeping
> LINES in env, but there is no real reason why
> LINES cannot be treated as an internal variable.
> Additionally, you get rid of the (small) kdb heap
> usage for LINES.
> 

Does any of this make sense :-)?

A
