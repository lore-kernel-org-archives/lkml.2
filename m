Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486Ab0GJWAV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 18:00:21 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48427 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800Ab0GJWAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 18:00:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=b0ATdaMk2jSoGImhtGV1ymAQugHZv9486qdVYiFFLh2A+jFvJKZO2+YADw5WpUpdCa
         n/RZNOW4iLP739XsqoyFdwcFa13KlRjD3J4tbCa/nmVTrROsZbKGWtYVYXDWsI7jur1M
         1TRPj/udVOZMJRWtsj3HiO4JPnst9eEhzudVY=
MIME-Version: 1.0
Date: Sat, 10 Jul 2010 18:00:19 -0400
Message-ID: <AANLkTimFWfCE8QCzCPPLH1L_KCvA_dZMBoCNjKk2JF2-@mail.gmail.com>
Subject: Calling system call from User-mode Linux?
From: Philip Wernersbach <dubs35@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm trying to add some functionality to User-mode Linux that requires
the UML kernel to call a custom syscall I've added to the host kernel.
This should be technically possible since UML runs in the userspace,
but I can't figure out how to call the syscall, as the syscall()
function isn't defined in UML. Are there other ways I can accomplish
this?

Thanks,
Phil
