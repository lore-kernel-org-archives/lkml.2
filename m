Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037Ab0K3Lrn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 06:47:43 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61012 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196Ab0K3Lrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 06:47:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=Jo4kP9S6cluUmZu3n5EANpwjce9LFyQH839RKf2KJaqj5rdv634NH2GQKaqIBo/lXe
         HQ+FIdRWYmu8f2YawGoLF8BXJyqQ79kJal87/8m75csFsqVFWnQ/yDKrZpWURLgOYCSX
         HPUCOCskXz+C+jOmwGSS695jaTuhGlF4vwpOM=
Subject: When was ASLR introduced in the Linux kernel?
From: Victor van der Veen <vvdveen@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Nov 2010 12:47:40 +0100
Message-ID: <1291117660.3206.11.camel@D430>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

- When was ASLR introduced in the Linux kernel (not PaX/ExecShield)? 
- When was ASLR enabled by default? 
- What's the current state of ASLR in the Linux kernel? Is it still
under development? Or should we rely on the PaX/ExecShield patches?

Wikipedia states that "a weak form of ASLR exists in the linux kernel
since version 2.6.12 (June 2005)", but I could not find any proof that
backs this up. I grepped changelogs of the entire 2.6 kernel, but I was
unable to find any relevant information. Grepping the source code did
not help either. Any more Google results all quote the same wikipedia
line. 

Thanks,
Victor van der Veen

