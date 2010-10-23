Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084Ab0JWNo4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 09:44:56 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39807 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757011Ab0JWNoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 09:44:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=WiENQY6qw1Jx+2p8LfSVKUzmyChxkW9Hy9EwDNDG6DCsfMsxnvJiFRpqoJwCYyBPlc
         /7gtVOa51qloEZMc39AktVtVmbdZu5mtm308lVxMohmzELgXQflgaUVxJUKS0Rd3Es5L
         cTM+KuOgMqq34Lm+06DwnTgriIiUlg2ATggj4=
Subject: A question on block_prepare_write()
From: Namhyung Kim <namhyung@gmail.com>
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 23 Oct 2010 22:44:42 +0900
Message-ID: <1287841482.1681.36.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I see block_prepare_write() has local variable wait[2] to keep track of
buffer_heads which are not up-to-date. But I'm wondering how it could be
guaranteed there will be no more than 2 such buffer_heads? Is there any
restriction on the usage of the function? Using MAX_BUF_PER_PAGE instead
of the magic number 2 is just useless? I couldn't find any comments or
documentation on this.

Any of your comments would be greatly appreciated. TIA. :-)

-- 
Regards,
Namhyung Kim


