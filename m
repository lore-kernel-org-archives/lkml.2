Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab1KIHMr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 02:12:47 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:37206 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279Ab1KIHMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 02:12:46 -0500
X-AuditID: cbfee61b-b7b7fae000005864-9c-4eba27ece20c
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Stephen Rothwell'" <sfr@canb.auug.org.au>
Cc: "'Kyungmin Park'" <kyungmin.park@samsung.com>, linux-next@vger.kernel.org,
        "'LKML'" <linux-kernel@vger.kernel.org>
References: <20111109082624.ea5697763c50ef9128244783@canb.auug.org.au>
 <003401cc9ea6$785e7dc0$691b7940$%kim@samsung.com>
 <20111109173722.a7f4c7d65c13bcb80bf2e6ba@canb.auug.org.au>
In-reply-to: <20111109173722.a7f4c7d65c13bcb80bf2e6ba@canb.auug.org.au>
Subject: RE: linux-next: incorrect build fix
Date: Wed, 09 Nov 2011 16:12:44 +0900
Message-id: <004e01cc9eae$fa5f4ef0$ef1decd0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Acyeqg79bP6tgiPvQoWviL3M2+OnjgABKavQ
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> 
> Hi,
> 
> On Wed, 09 Nov 2011 15:11:50 +0900 Kukjin Kim <kgene.kim@samsung.com>
> wrote:
> >
> > I'm not sure following......
> > So only for THIS_MODULE, <linux/export.h> should be added instead of
> > <linux/module.h>?
> 
> Yes, that is correct.   It means that much less code is included.  If
> replacing module.h with export.h causes other build errors, they should
> be fixed by including the correct files directly (module.h include a lot
> of other include files).

I agree, okay. Will update Samsung stuff :)

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

