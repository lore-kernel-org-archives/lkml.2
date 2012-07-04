Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933255Ab2GDDIa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 23:08:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50219 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756016Ab2GDDIZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 23:08:25 -0400
From: "Du, Changbin" <changbin.du@gmail.com>
To: "=?utf-8?Q?'Beno=C3=AEt_Th=C3=A9baudeau'?=" 
	<benoit.thebaudeau@advansee.com>
Cc: <tsoni@codeaurora.org>, "'dan carpenter'" <dan.carpenter@oracle.com>,
        <kumarrav@codeaurora.org>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <mchehab@infradead.org>
References: <4ff2c90c.83e6440a.48b4.3727@mx.google.com> <539669167.615856.1341314356547.JavaMail.root@advansee.com>
In-Reply-To: <539669167.615856.1341314356547.JavaMail.root@advansee.com>
Subject: RE: [PATCH] media: gpio-ir-recv: add allowed_protos and map_name for platform data
Date: Wed, 4 Jul 2012 11:08:14 +0800
Message-ID: <4ff3b3a8.c4ed440a.02c0.ffffe9dc@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Ac1ZDQb4Ka76yCUATlGwPSM3h6zpBgAhRilA
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi Changbin,
> 
> On Tue, Jul 3, 2012 at 12:27:19PM +0200, Changbin Du wrote:
> > It's better to give platform code a chance to specify the allowed
> > protocols and which keymap to use.
> 
> Already half done here:
> http://git.linuxtv.org/media_tree.git?a=commitdiff;h=2bd237b

Got it, thanks. 

[Du, ChangbinX] 
> Regards,
> Benoît

