Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab0FYIZh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 04:25:37 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57687 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab0FYIZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 04:25:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=JUiBC8X8onLaIFggLa3DqPLQZflau5J8MG/Eo3TaYtm8weByLuZ5MpBkCAPEhN/i/3
         9sUovQWUSA9vGeVTYCrYKYxUA0PdXmVn2LNmyxiAkf9aoDJMClrga9djB5aLHz+V6Xa3
         9i0O/NjwPsQGponVw/E+ZuodEfQbvdB4rIUxM=
MIME-Version: 1.0
Date: Fri, 25 Jun 2010 13:55:32 +0530
Message-ID: <AANLkTinYuxwsLQKGRd6joRSCcbnns930DDienlhfEB8i@mail.gmail.com>
Subject: Setting up Silicon image 3114 in DMA mode
From: amruth pattanada <amruth.vamadev@gmail.com>
To: jeff@garzik.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
Can anybody please guide me what minimal steps to follow for setting
up 3114 for operating in DMA mode and looked into linux 2.6.32.7 code.
I am porting 3114 driver to RTOS but have problems in using BAR5 PCI
config space because of Memory mapped region issues. I can access BAR4
and plan to set up DMA mode.
How do we access entire BAR5 memory space without using BAR5, is there
any indirect way to access BAR5 using BAR4. Please let me know.
Thanks
Amruth p.v
Sr.Embedded Engineer
