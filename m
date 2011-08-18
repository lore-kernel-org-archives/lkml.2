Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165Ab1HRHHY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 03:07:24 -0400
Received: from www.meduna.org ([92.240.244.38]:38695 "EHLO meduna.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665Ab1HRHHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 03:07:23 -0400
X-Greylist: delayed 2265 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Aug 2011 03:07:23 EDT
Message-ID: <4E4CB13C.7010502@meduna.org>
Date: Thu, 18 Aug 2011 08:29:16 +0200
From: Stanislav Meduna <stano@meduna.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.20) Gecko/20110804 Lightning/1.0b2 Thunderbird/3.1.12
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: linux-kernel@vger.kernel.org, gunnarlindroth@hotmail.com,
        user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [uml-devel] Floating point problems on UML - help needed
References: <4E4C2B6F.7000800@nod.at>
In-Reply-To: <4E4C2B6F.7000800@nod.at>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Authenticated-User: stano@meduna.org
X-Authenticator: dovecot_plain
X-Spam-Score: -8.3
X-Spam-Score-Int: -82
X-Exim-Version: 4.69 (build at 30-Jan-2011 20:48:48)
X-Date: 2011-08-18 08:29:28
X-Connected-IP: 95.105.188.244:2318
X-Message-Linecount: 31
X-Body-Linecount: 17
X-Message-Size: 1148
X-Body-Size: 511
X-Received-Count: 1
X-Recipient-Count: 4
X-Local-Recipient-Count: 4
X-Local-Recipient-Defer-Count: 0
X-Local-Recipient-Fail-Count: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.08.2011 22:58, Richard Weinberger wrote:

> It looks like FPU registers get sometimes lost after switching between
> two or more threads.

This is probably a bug in UML I reported nearly three years ago.
For me mode=skas0 worked aruond the issue.

http://thread.gmane.org/gmane.linux.uml.devel/11824/focus=11840

You might try the patch posted in
http://thread.gmane.org/gmane.linux.uml.devel/12158
(I don't have the environment to test it anymore)

Regards
-- 
                                     Stano
