Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694Ab1GGJCX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 05:02:23 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:33470 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062Ab1GGJCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 05:02:19 -0400
MIME-Version: 1.0
In-Reply-To: <CAN_5kQDTweB2GLvwgjN+BQuqnhFUp+MOcQr=ZW=8C6XSsC8XtA@mail.gmail.com>
References: <CAN_5kQDTweB2GLvwgjN+BQuqnhFUp+MOcQr=ZW=8C6XSsC8XtA@mail.gmail.com>
Date: Thu, 7 Jul 2011 10:02:17 +0100
X-Google-Sender-Auth: Tbl8i8NSwPtoFainjjn0p7347N8
Message-ID: <CAHkRjk6WNu5h=QCN-8EfyHHG=0MiX4qbcqHiPws=hgXOf2bvMQ@mail.gmail.com>
Subject: Re: [PATCH] remove unnecessary cache flush on v6 copypage
From: Catalin Marinas <catalin.marinas@arm.com>
To: heechul Yun <heechul@illinois.edu>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 7, 2011, heechul Yun <heechul@illinois.edu> wrote:
> ARM: mm: remove unnecessary cache flush on v6 copypage
>
> Signed-off-by: Heechul Yun <heechul@illinois.edu>

I would clarify the commit log a bit stating that this flush is no
longer necessary because of commit c0177800. We had a good reason for
adding the flush initially.

Otherwise,

Acked-by: Catalin Marinas <catalin.marinas@arm.com>


-- 
Catalin
