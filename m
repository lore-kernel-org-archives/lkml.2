Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757842Ab2IJMp3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 08:45:29 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:47044 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757690Ab2IJMp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 08:45:26 -0400
MIME-Version: 1.0
In-Reply-To: <CALF0-+U_D4ipSbN=DHSdxRvE1sju-Uq0e_mTE9=QsjLOtpLe1w@mail.gmail.com>
References: <1347112918-7738-1-git-send-email-peter.senna@gmail.com>
	<CALF0-+U_D4ipSbN=DHSdxRvE1sju-Uq0e_mTE9=QsjLOtpLe1w@mail.gmail.com>
Date: Mon, 10 Sep 2012 14:45:24 +0200
Message-ID: <CA+MoWDq12HEtA4xODddMzqEOENQDgx4MzbogFe4uprm93CvvOw@mail.gmail.com>
Subject: Re: [PATCH v2] drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c:
 fix error return code
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        kernel-janitors@vger.kernel.org, wharms@bfs.de, Julia.Lawall@lip6.fr,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> You're replacing kmemdup for kstrdup, which is great,
> but that's not anywhere in the commit message.
Sorry for that.

>
> I'm not sure if you should re-send, but you should definitely
> try to have better commit messages in the future!
I'll kindly ask to ignore the V2 of this patch. I'll send other patch
to be applied after the V1. The second patch will replace kmemdup for
kstrdup. Please ignore the patch:
http://patchwork.linuxtv.org/patch/14237/

>
> Not to mention you're doing two things in one patch, and that makes
> very difficult to bisect.
This is really bad thing to do in a single patch. Sorry for that too.

>
> Thanks (and sorry for the nitpick)...

Thanks!

> Ezequiel.



-- 
Peter
