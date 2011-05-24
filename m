Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933516Ab1EXW3n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 18:29:43 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42063 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757466Ab1EXW3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 18:29:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=NsAn2TFQEJ3IbuWskYbBHMcwqy9F5XJdcErlP8o3d7S9oG84IZYPRjvc11QInuoLvj
         L9o7LyvPTVTLv2WOaSqR2nd4excrAAz/kRgLGv44dAiTPR7RR59rk/sOQc76FwFc5FFQ
         WLcfvlx9b1oQdnamTn6SjcGEAsukjLjoqogTc=
MIME-Version: 1.0
Date: Tue, 24 May 2011 15:29:40 -0700
Message-ID: <BANLkTinMJZq_Wkf41Q-MRn4uC17hEsKUqQ@mail.gmail.com>
Subject: TCP session management
From: Nauman Tahir <nauman.tahir@gmail.com>
To: Kernel Newbies <kernelnewbies@nl.linux.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I am interested in learning about highly practiced/recommended
algorithms used for TCP session management in the stack. I am writing
code for an embedded processor which needs to process TCP/IP flows and
it does not have the stack. I am interested in implementing most
efficient algorithm to maintain/lookup about 5 million full duplex TCP
sessions.

Any ideas, pointers would be greatly appreciated.

Thanks
Nauman
