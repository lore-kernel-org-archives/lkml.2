Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab1A1SDN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 13:03:13 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58810 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754999Ab1A1SDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 13:03:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=A7tzrdIGQLlU0cqyd1q+lopr5MtPhSThJEx4KYbdg2i6PNmI7lT5tEOGCWb7G48NQc
         cL+CScrvvcBLVUn04GNeBZRMM50YQM+7U6WhtSDd0PeMB3oHbEKAOmQuA2hXyksvTN+m
         9qsMIHUK82vqXswYTNaPyhJFgxKHYcynSjxd8=
MIME-Version: 1.0
Date: Fri, 28 Jan 2011 16:03:11 -0200
Message-ID: <AANLkTikrKEY7Zt5HvxQcJLk9eGne0BGD82NFEiWO4smt@mail.gmail.com>
Subject: jme driver loses connection after resuming from suspend
From: "Leonardo  L. P. da Mata" <barroca@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, i'm testing the kernel 2.6.37 on my hardware, Once connect on
wired network, i call the suspend with:
echo "mem" >/sys/power/state

The system goes on suspend. After resuming from suspend, the network card
cannot be used anymore.


The bug is reported here:
 https://bugzilla.kernel.org/show_bug.cgi?id=27692

Can you please point me to similar problems on other network cards so
i can get possible solutions on this.



-- 
Leonardo Luiz Padovani da Mata
barroca@gmail.com

"May the force be with you, always"
"Nerd Pride... eu tenho. Voce tem?"
