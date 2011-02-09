Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab1BIXpn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 18:45:43 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64878 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616Ab1BIXpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 18:45:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=S0OW2AQxToznEVPrECqIakLdHQJ91V8mSqR526bN4S8xpxcsfn/iLg4xeG7T/NOHzw
         TgKjvUDTI84D3yyflPhANBDqPrdJ0C/Rt6ZLJ8opvAtATKDRU/hpuRKGy/4+o/dDQDyJ
         4n5RI6DLu9D3cF/aXXvqhbvZXwGtQ2Hcil9qw=
MIME-Version: 1.0
Date: Wed, 9 Feb 2011 18:45:42 -0500
Message-ID: <AANLkTi=Ca4Lcc_war-atpr81eJcZA3ks+EKFf9Rq5pKs@mail.gmail.com>
Subject: Mapping memory between kernel and user space
From: Sri Ram Vemulpali <sri.ram.gmu06@gmail.com>
To: Kernel-newbies <kernelnewbies@nl.linux.org>,
        linux-kernel-mail <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

  How do I map some space between kernel and user space. Can anyone
point me in to right direction. I was trying to map the packets from
my netfilter function to kernel user space, to avoid over head of
copying. Thanks in advance.

-- 
Regards,
Sri.
