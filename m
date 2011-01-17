Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925Ab1AQWKr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 17:10:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1510 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751878Ab1AQWKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 17:10:45 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Tejun Heo <tj@kernel.org>
X-Fcc: ~/Mail/linus
Cc: oleg@redhat.com, linux-kernel@vger.kernel.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Subject: Re: [PATCH 3/4] signal: remove superflous try_to_freeze() loop in do_signal_stop()
In-Reply-To: Tejun Heo's message of  Wednesday, 22 December 2010 12:13:17 +0100 <1293016398-18001-4-git-send-email-tj@kernel.org>
References: <1293016398-18001-1-git-send-email-tj@kernel.org>
	<1293016398-18001-4-git-send-email-tj@kernel.org>
X-Zippy-Says: The Osmonds!  You are all Osmonds!!  Throwing up on a freeway at dawn!!!
Message-Id: <20110117221042.41DD8180996@magilla.sf.frob.com>
Date: Mon, 17 Jan 2011 14:10:42 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Roland McGrath <roland@redhat.com>
