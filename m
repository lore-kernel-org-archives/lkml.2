Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837Ab2BYDU5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 22:20:57 -0500
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:33054 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752769Ab2BYDU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 22:20:56 -0500
Date: Fri, 24 Feb 2012 19:20:56 -0800 (PST)
From: Andrei Warkentin <awarkentin@vmware.com>
To: linux-kernel@vger.kernel.org
Cc: jason wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net
Message-ID: <1307333479.1554115.1330140056092.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
In-Reply-To: <1329522773-21359-1-git-send-email-andreiw@vmware.com>
Subject: Re: [PATCH] KDB: Fix usability issues relating to the 'enter' key.
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
> Sent: Friday, February 17, 2012 6:52:53 PM
> Subject: [PATCH] KDB: Fix usability issues relating to the 'enter' key.
> 
> This fixes the following problems:
> 1) Typematic-repeat of 'enter' gives warning message.
> 2) Use of 'keypad enter' gives warning message.
> 3) Lag on the order of seconds between "break" and "make" when
>    expecting the enter "break" code. Seen under virtualized
>    environments such as VMware ESX.
> 

Does this seem reasonable :-)?

A
