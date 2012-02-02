Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359Ab2BBVKx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 16:10:53 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61798 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755385Ab2BBVKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 16:10:51 -0500
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 2 Feb 2012 14:10:31 -0700
X-Google-Sender-Auth: R-h8oAM9lxqz-a2b8edF_0GRX_s
Message-ID: <CACxGe6sTO_Jy-vecKS9SoVs55ZA8BMc+O0NODLdq6KvkcbPByg@mail.gmail.com>
Subject: Please add irqdomain branch to linux-next
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

Can you please add the following branch to linux-next?  It contains
the majority of the irqdomain rework that I've been doing.  I'd like
to get it marinating in linux-next early so I'm sure it will be ready
when the v3.4 merge window rolls around.

git://git.secretlab.ca/git/linux-2.6.git irqdomain/next

Thanks,
g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
