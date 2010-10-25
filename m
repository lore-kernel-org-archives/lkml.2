Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774Ab0JYP5X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 11:57:23 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35106
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754689Ab0JYP5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 11:57:22 -0400
Date: Mon, 25 Oct 2010 08:57:45 -0700 (PDT)
Message-Id: <20101025.085745.193706566.davem@davemloft.net>
To: namhyung@gmail.com
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] sparc: don't #include asm/system.h in
 asm/jump_label.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <1288021958-3130-1-git-send-email-namhyung@gmail.com>
References: <1288021958-3130-1-git-send-email-namhyung@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@gmail.com>
Date: Tue, 26 Oct 2010 00:52:36 +0900

> It seems that #include <asm/system.h> makes a circular dependency
> between kernel.h and bitmap.h which breaks allmodconfig build.
> Removing the line makes no change because jump_label.h doesn't
> need it actually AFAICS. Compile tested on sparc32 allmodconfig.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>

Acked-by: David S. Miller <davem@davemloft.net>
