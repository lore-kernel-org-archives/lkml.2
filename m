Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067Ab0IBSc3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 14:32:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753142Ab0IBSc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 14:32:28 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Namhyung Kim <namhyung@gmail.com>
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 02/24] ptrace: cleanup ptrace_request()
In-Reply-To: Namhyung Kim's message of  Friday, 3 September 2010 00:46:09 +0900 <1283442391-23612-3-git-send-email-namhyung@gmail.com>
References: <1283442391-23612-1-git-send-email-namhyung@gmail.com>
	<1283442391-23612-3-git-send-email-namhyung@gmail.com>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20100902183210.0CA3C40465@magilla.sf.frob.com>
Date: Thu,  2 Sep 2010 11:32:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You've still changed put_user to copy_to_user here.
I thought you'd agreed not to change that.

Thanks,
Roland
