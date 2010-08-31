Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131Ab0HaXbh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 19:31:37 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41578 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab0HaXbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 19:31:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=g3oSFCB5nrpV7xGGUegZzD9pEPPHf9kDwRS4uNcW5BzesheE4Xv1M91KaxV+RTlWKF
         JYU3I4+Bn2H3SbJ6CfgPh7JC+OsE76Due7cqdNj7FovPhZRMenqHct9EjzHo03fjQzZL
         e2fHcarj/bauWCJIdWY7vFjUVPzUNz88mQvao=
Subject: Re: [PATCH] ARM: pxa3xx: fix build error when
 CONFIG_MTD_PARTITIONS is not defined
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: "Mark F. Brown" <mark.brown314@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTinn_Yb+jGOcpc139X2cW0ax5Ev23ovjpp9NrPJC@mail.gmail.com>
References: <1282813011-6187-1-git-send-email-mark.brown314@gmail.com>
	 <1282813011-6187-2-git-send-email-mark.brown314@gmail.com>
	 <AANLkTinn_Yb+jGOcpc139X2cW0ax5Ev23ovjpp9NrPJC@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Sep 2010 02:31:32 +0300
Message-ID: <1283297492.2018.62.camel@brekeke>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-31 at 13:51 +0800, Haojian Zhuang wrote:
> Hi Mark,
> 
> Don't forget to cc maintainer of mtd tree. I loop them now.

FYI, the MTD maintainer id dwmw2, I'm just helping him sometimes.

-- 
Best Regards,
Artem Bityutskiy (Битюцкий Артём)

