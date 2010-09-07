Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758101Ab0IGTCn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 15:02:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8280 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757217Ab0IGTCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 15:02:40 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Namhyung Kim <namhyung@gmail.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] exit: add lock context annotation on find_new_reaper()
In-Reply-To: Namhyung Kim's message of  Tuesday, 7 September 2010 21:35:26 +0900 <1283862926-17406-1-git-send-email-namhyung@gmail.com>
References: <1283862926-17406-1-git-send-email-namhyung@gmail.com>
X-Windows: a moment of convenience, a lifetime of regret.
Message-Id: <20100907190230.9893640161@magilla.sf.frob.com>
Date: Tue,  7 Sep 2010 12:02:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Roland McGrath <roland@redhat.com>
