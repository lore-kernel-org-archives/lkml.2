Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035Ab0L1Buk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 20:50:40 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:27416 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625Ab0L1Buj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 20:50:39 -0500
Date: Sun, 26 Dec 2010 18:13:19 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-kernel@vger.kernel.org, Alex Dubov <oakad@yahoo.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: mmotm 2010-12-23-16-58 uploaded
Message-Id: <20101226181319.6ae709d9.randy.dunlap@oracle.com>
In-Reply-To: <201012240132.oBO1W8Ub022207@imap1.linux-foundation.org>
References: <201012240132.oBO1W8Ub022207@imap1.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Dec 2010 16:58:58 -0800 akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2010-12-23-16-58 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
> 
>    git://zen-kernel.org/kernel/mmotm.git
> 
> It contains the following patches against 2.6.37-rc7:

> memstick-factor-out-transfer-initiating-functionality-in-mspro_blockc.patch

drivers/memstick/core/mspro_block.c:1090: warning: format '%x' expects type 'unsigned int', but argument 7 has type 'size_t'

change "size %x" to "size %zx"

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
desserts:  http://www.xenotime.net/linux/recipes/
