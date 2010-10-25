Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675Ab0JYPwT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 11:52:19 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:58753 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756590Ab0JYPwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 11:52:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=gDlPa7/8FobBtSFx3HmrmSHMqvb6V8zOoD788KjUifclo02UKqhNbI4xMIURHHTweH
         g8P6UEMpjZ4I7w4NDW7sSVN3EBOb4AM+U37jNi/o3PG8vjLOytmlejt4jsJksifkrmhJ
         a314L1H1QFp2Z/Xxc2lYYQflVsQNcHrXAm1Wg=
MIME-Version: 1.0
Date: Mon, 25 Oct 2010 19:52:17 +0400
Message-ID: <AANLkTikx2TYO_NN91FzOq_0wxOJ_ggQVsxgOHNOpRom5@mail.gmail.com>
Subject: Adding more stuff to devres.
From: Alexey Zaytsev <alexey.zaytsev@gmail.com>
To: Kernel development list <linux-kernel@vger.kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Kumar Gala <galak@kernel.crashing.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Would it be a good idea to get things other than resources managed by
the devres?

In my probe() method, I still have to handle alloc_netdev() and
mdiobus_alloc(). Adding corresponding devm_ functions should be
trivial. So, should I prepare the patches, or is there something wrong
with the approach?
