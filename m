Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853Ab0IRAPh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 20:15:37 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51204
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752302Ab0IRAPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 20:15:36 -0400
Date: Fri, 17 Sep 2010 17:15:54 -0700 (PDT)
Message-Id: <20100917.171554.94863674.davem@davemloft.net>
To: james@albanarts.com
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, airlied@redhat.com,
        akpm@linux-foundation.org, marcin.slusarz@gmail.com,
        FlorianSchandinat@gmx.de, vda.linux@googlemail.com,
        jbarnes@virtuousgeek.org, jsimmons@infradead.org
Subject: Re: [PATCH] fbmem: Fix fb_read, fb_write unaligned accesses.
From: David Miller <davem@davemloft.net>
In-Reply-To: <201009180057.32358.james@albanarts.com>
References: <201009092338.59880.james@albanarts.com>
	<201009180057.32358.james@albanarts.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Nobody can test your patch because your email client corrupted
it, by breaking up long lines.
