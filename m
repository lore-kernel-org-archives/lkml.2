Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab0KASB1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 14:01:27 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:56148 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815Ab0KASB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 14:01:26 -0400
Date: Mon, 1 Nov 2010 11:00:24 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-kernel@vger.kernel.org, Matti Aaltonen <matti.j.aaltonen@nokia.com>
Cc: akpm@linux-foundation.org, Jari Vanhala <ext-jari.vanhala@nokia.com>
Subject: Re: mmotm 2010-10-31-21-24 uploaded (drivers/nfc/pn544)
Message-Id: <20101101110024.bca61c57.randy.dunlap@oracle.com>
In-Reply-To: <201011010427.oA14R3Y6010534@imap1.linux-foundation.org>
References: <201011010427.oA14R3Y6010534@imap1.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 31 Oct 2010 21:25:59 -0700 akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2010-10-31-21-24 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
> 
>    git://zen-kernel.org/kernel/mmotm.git
> 
> It contains the following patches against 2.6.36:
> 
> nfc-driver-for-nxp-semiconductors-pn544-nfc-chip.patch


Use %zd to print ssize_t variables and %zu to print size_t:

drivers/nfc/pn544.c:332: warning: format '%d' expects type 'int', but argument 6 has type 'size_t'
drivers/nfc/pn544.c:442: warning: format '%d' expects type 'int', but argument 6 has type 'size_t'


Also see Documentation/printk-formats.txt as needed.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
