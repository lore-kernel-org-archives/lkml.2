Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002Ab0EKOzf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 10:55:35 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:48113 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754839Ab0EKOzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 10:55:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=UBYS2Eiuff8LFtUP8aAdXakjebxqF3MjslRkmxCv1FHvq4mPjwDGx8+ITMnG6dCBj6
         dRandQFzOzYRSc1CLT4iKcrkkLkQPsVAwzErjfwlfyiuFZiMcRE3ubflobXO5hB3BHek
         vOOOY1+5fd3pEo9Rc7mPMLF3o40Adzn3NLnPw=
MIME-Version: 1.0
Date: Tue, 11 May 2010 20:25:31 +0530
Message-ID: <AANLkTilF304TbgACKtvc_FA01uxHrdRBS2Q-o6Tm-n8Q@mail.gmail.com>
Subject: ACPI Errors on Acer Aspire One
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Linux ACPI <linux-acpi@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

With latest git kernel, I am getting following ACPI errors :

[    0.289038] ACPI Error (dsfield-0143): [CAPB] Namespace lookup
failure, AE_ALREADY_EXISTS
[    0.289399] ACPI Error (psparse-0537): Method parse/execution
failed [\_SB_.PCI0._OSC] (Node f70477e8), AE_ALREADY_EXISTS
[    0.299684] ACPI Error (dsfield-0143): [CAPB] Namespace lookup
failure, AE_ALREADY_EXISTS
[    0.300007] ACPI Error (psparse-0537): Method parse/execution
failed [\_SB_.PCI0._OSC] (Node f70477e8), AE_ALREADY_EXISTS


dmesg : http://userweb.kernel.org/~jaswinder/acer_netbook/dmesg_2634-rc7.txt
.config : http://userweb.kernel.org/~jaswinder/acer_netbook/config_2634-rc7.txt

How can I fix these errors.

Thanks,
--
Jaswinder Singh.
