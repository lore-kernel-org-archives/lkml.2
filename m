Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438Ab1A1Ssk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 13:48:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4013 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754628Ab1A1Ssj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 13:48:39 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Tejun Heo <tj@kernel.org>
X-Fcc: ~/Mail/linus
Cc: oleg@redhat.com, jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 05/10] ptrace: add @why to ptrace_stop()
In-Reply-To: Tejun Heo's message of  Friday, 28 January 2011 16:08:39 +0100 <1296227324-25295-6-git-send-email-tj@kernel.org>
References: <1296227324-25295-1-git-send-email-tj@kernel.org>
	<1296227324-25295-6-git-send-email-tj@kernel.org>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20110128184809.825B8180996@magilla.sf.frob.com>
Date: Fri, 28 Jan 2011 10:48:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ptrace, add @why to ptrace_stop().  Existing users are updateda such
								^
log typo.

Otherwise,

Acked-by: Roland McGrath <roland@redhat.com>
