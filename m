Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227Ab0KXSvs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 13:51:48 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:62399 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691Ab0KXSvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 13:51:47 -0500
Date: Wed, 24 Nov 2010 10:51:26 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: akpm@linux-foundation.org, Daniel Drake <dsd@laptop.org>,
        Andres Salomon <dilinger@debian.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: mmotm 2010-11-23-16-12 uploaded (olpc)
Message-Id: <20101124105126.8248fc1f.randy.dunlap@oracle.com>
In-Reply-To: <201011240045.oAO0jYQ5016010@imap1.linux-foundation.org>
References: <201011240045.oAO0jYQ5016010@imap1.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Nov 2010 16:13:06 -0800 akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2010-11-23-16-12 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
> 
>    git://zen-kernel.org/kernel/mmotm.git


make[4]: *** No rule to make target `arch/x86/platform/olpc/olpc-xo1-wakeup.c', needed by `arch/x86/platform/olpc/olpc-xo1-wakeup.o'.


It's olpc-xo1-wakeup.S, so I guess it needs a special makefile rule ??

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
