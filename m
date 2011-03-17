Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034Ab1CQJMo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 05:12:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:37615 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936Ab1CQJMl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 05:12:41 -0400
Subject: Re: [PATCH 1/2 v2] watchdog, nmi:  Allow hardlockup to panic by
 default
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: x86@kernel.org, jwjstone@fastmail.fm, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1299533860-1642-1-git-send-email-dzickus@redhat.com>
References: <1299533860-1642-1-git-send-email-dzickus@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 17 Mar 2011 10:12:29 +0100
Message-ID: <1300353149.2203.2766.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-07 at 16:37 -0500, Don Zickus wrote:
> Add a Kconfig option to allow users to set the hardlockup to panic
> by default.  Also add in a 'nmi_watchdog=nopanic' to override this.
> 
> v2:
>   clean up a typo
> 
> Signed-off-by: Don Zickus <dzickus@redhat.com>

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

