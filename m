Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932285Ab0I3S7x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 14:59:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55456
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932189Ab0I3S7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 14:59:51 -0400
Date: Thu, 30 Sep 2010 12:00:11 -0700 (PDT)
Message-Id: <20100930.120011.42789282.davem@davemloft.net>
To: namhyung@gmail.com
Cc: akpm@linux-foundation.org, roland@redhat.com, oleg@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v3 21/24] ptrace: cleanup arch_ptrace() on sparc
From: David Miller <davem@davemloft.net>
In-Reply-To: <1285838880-4977-22-git-send-email-namhyung@gmail.com>
References: <1285838880-4977-1-git-send-email-namhyung@gmail.com>
	<1285838880-4977-22-git-send-email-namhyung@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@gmail.com>
Date: Thu, 30 Sep 2010 18:27:56 +0900

> Factor out struct fps and remove redundant castings.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>

Acked-by: David S. Miller <davem@davemloft.net>
