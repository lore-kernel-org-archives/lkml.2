Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829Ab1AQWPI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 17:15:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54505 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751878Ab1AQWPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 17:15:03 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Tejun Heo <tj@kernel.org>
X-Fcc: ~/Mail/linus
Cc: oleg@redhat.com, linux-kernel@vger.kernel.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Subject: Re: [PATCH 4/4] ptrace: kill tracehook_notify_jctl()
In-Reply-To: Tejun Heo's message of  Wednesday, 22 December 2010 12:13:18 +0100 <1293016398-18001-5-git-send-email-tj@kernel.org>
References: <1293016398-18001-1-git-send-email-tj@kernel.org>
	<1293016398-18001-5-git-send-email-tj@kernel.org>
X-Windows: complex nonsolutions to simple nonproblems.
Message-Id: <20110117221459.866B1180996@magilla.sf.frob.com>
Date: Mon, 17 Jan 2011 14:14:59 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This causes problems for our unmerged patch-sets, but I'll leave it Oleg to
decide if it's OK to remove this hook now.

Thanks,
Roland

