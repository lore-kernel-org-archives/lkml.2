Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932763Ab2GCLOh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 07:14:37 -0400
Received: from zose-mta13.web4all.fr ([178.33.204.91]:45000 "EHLO
	zose-mta13.web4all.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932389Ab2GCLOf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 07:14:35 -0400
Date: Tue, 3 Jul 2012 13:19:16 +0200 (CEST)
From: =?utf-8?Q?Beno=C3=AEt_Th=C3=A9baudeau?= 
	<benoit.thebaudeau@advansee.com>
To: Changbin Du <changbin.du@gmail.com>
Cc: tsoni@codeaurora.org, dan carpenter <dan.carpenter@oracle.com>,
        kumarrav@codeaurora.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, mchehab@infradead.org
Message-ID: <539669167.615856.1341314356547.JavaMail.root@advansee.com>
In-Reply-To: <4ff2c90c.83e6440a.48b4.3727@mx.google.com>
Subject: Re: [PATCH] media: gpio-ir-recv: add allowed_protos and map_name
 for platform data
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [88.188.188.98]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - FF3.0 (Win)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Changbin,

On Tue, Jul 3, 2012 at 12:27:19PM +0200, Changbin Du wrote:
> It's better to give platform code a chance to specify the allowed
> protocols and which keymap to use.

Already half done here:
http://git.linuxtv.org/media_tree.git?a=commitdiff;h=2bd237b

Regards,
Benoît
