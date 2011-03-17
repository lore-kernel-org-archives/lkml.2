Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133Ab1CQJS5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 05:18:57 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53709 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936Ab1CQJSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 05:18:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=ec8PRPC4ZmwvcTNXEWXKK7PrMNfij/m05VxxH/oA9FRJoCkTD+tAjOGJMKeQZ6quOj
         cZZVFchvuest0v1XCXcjim3ZEb3Iv142mcrMIIvRfj0P9MhEvEkmkPEfbjAHZYzPYQHr
         4IogO/GfNtwfZd36i9MH9b0FwP2Pv7diuOS9Y=
MIME-Version: 1.0
Date: Thu, 17 Mar 2011 14:48:53 +0530
Message-ID: <AANLkTi=GNcnEbLdivFZEMinm4FOYrMZGqTVfq0-C4yu4@mail.gmail.com>
Subject: Support for ARM940T core Samsung S3C2510A MCU under Linux
From: Madhavi Manchala <madhavi.linux@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear All,

I have one basic question about the architecture files in Linux
kernels. We have a board with Samsung S3C2510A MCU (ARM940T core)
which is a no-mmu based CPU. I heard that "there was not a lot of ARM
no-mmu support at the moment" from Ben Dooks.

So, I started developing the architecture files for my Samsung
S3C2510A MCU (ARM940T core) by looking at the existing S3C2410A
(ARM920 core) architecture files. Is this my porting (developing the
architecture files) correct?

How can I port the Linux on to my board which has a Samsung S3C2510A
MCU (ARM940T core) which is a NO-MMU based CPU?

Thanks for your suggestions / hints / comments.

Thanks and Regards,
Madhavi M.
