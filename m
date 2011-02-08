Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809Ab1BHDWx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 22:22:53 -0500
Received: from xenotime.net ([72.52.115.56]:33424 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750931Ab1BHDWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 22:22:52 -0500
Date: Mon, 7 Feb 2011 19:22:49 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Harry Wei <jiaweiwei.xiyou@gmail.com>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, joe@perches.com,
        akpm@linux-foundation.org, greg@kroah.com
Subject: Re: [PATCH]Maintain Chinese Documentations
Message-Id: <20110207192249.5a478469.rdunlap@xenotime.net>
In-Reply-To: <20110208031638.GA4828@gmail.com>
References: <20110208023735.GA4599@gmail.com>
	<20110207184027.468e2a03.rdunlap@xenotime.net>
	<AANLkTimacOStZv-hrxo6iOWUDNem+h1cmaKCZQzw=0jr@mail.gmail.com>
	<20110208031638.GA4828@gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Hi Harry,

a.  Omit my previous comments, just make a new patch with description.

b.  This line:
+F:	Documentation/zh_CN

should have a trailing '/' on it to indicate that it is a directory.

c.  After
> Signed-off-by: Harry Wei <harryxiyou@gmail.com>

you can add this line:
Acked-by: Randy Dunlap <rdunlap@xenotime.net>


Thanks.
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
