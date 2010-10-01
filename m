Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183Ab0JAWld (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 18:41:33 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:27277 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab0JAWlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 18:41:32 -0400
Date: Fri, 1 Oct 2010 15:41:19 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Marek Belisko <marek.belisko@gmail.com>, gregkh@suse.de
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        driverdevel <devel@driverdev.osuosl.org>
Subject: Re: linux-next: Tree for October 1 (staging/ft1000)
Message-Id: <20101001154119.ec81d975.randy.dunlap@oracle.com>
In-Reply-To: <20101001153756.47b52566.sfr@canb.auug.org.au>
References: <20101001153756.47b52566.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Oct 2010 15:37:56 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20100930:


drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c:84: warning: initialization from incompatible pointer type
drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c:880: warning: the frame size of 2064 bytes is larger than 2048 bytes



---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
