Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000Ab0I3S6J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 14:58:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55451
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753384Ab0I3S6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 14:58:07 -0400
Date: Thu, 30 Sep 2010 11:58:28 -0700 (PDT)
Message-Id: <20100930.115828.57462004.davem@davemloft.net>
To: namhyung@gmail.com
Cc: akpm@linux-foundation.org, roland@redhat.com, oleg@redhat.com,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH RESEND v3 03/24] ptrace: change signature of
 arch_ptrace()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1285838880-4977-4-git-send-email-namhyung@gmail.com>
References: <1285838880-4977-1-git-send-email-namhyung@gmail.com>
	<1285838880-4977-4-git-send-email-namhyung@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@gmail.com>
Date: Thu, 30 Sep 2010 18:27:38 +0900

> Fix up the arguments to arch_ptrace() to take account of the fact that
> @addr and @data are now unsigned long rather than long as of a preceding
> patch in this series.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> Cc: linux-arch@vger.kernel.org
> Acked-by: Roland McGrath <roland@redhat.com>
> Acked-by: David Howells <dhowells@redhat.com>

Acked-by: David S. Miller <davem@davemloft.net>
