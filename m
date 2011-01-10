Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab1AJQ5D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 11:57:03 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:34479 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434Ab1AJQ5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 11:57:00 -0500
Date: Mon, 10 Jan 2011 08:56:24 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, x86@kernel.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for January 10 (x86/e820)
Message-Id: <20110110085624.5765860a.randy.dunlap@oracle.com>
In-Reply-To: <20110110154947.31c3eac7.sfr@canb.auug.org.au>
References: <20110110154947.31c3eac7.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Jan 2011 15:49:47 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> Reminder: do not add any v2.6.39 material to your linux-next included
> trees until after v2.6.38-rc1 is released.
> 
> Changes since 20110107:


When CONFIG_ACPI is not enabled:

arch/x86/kernel/e820.c:734: error:implicit declaration of function 'suspend_nvs_register'


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
