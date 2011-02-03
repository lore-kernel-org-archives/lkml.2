Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756459Ab1BCPh1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 10:37:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13458 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756438Ab1BCPhZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 10:37:25 -0500
Date: Thu, 3 Feb 2011 13:17:17 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, aliguori@us.ibm.com,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [PATCH v2] release kvmclock page on reset
Message-ID: <20110203151717.GA6967@amt.cnet>
References: <1296587800-19589-1-git-send-email-glommer@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296587800-19589-1-git-send-email-glommer@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 02:16:40PM -0500, Glauber Costa wrote:
> When a vcpu is reset, kvmclock page keeps being writen to this days.
> This is wrong and inconsistent: a cpu reset should take it to its
> initial state.
> 
> Signed-off-by: Glauber Costa <glommer@redhat.com>
> CC: Jan Kiszka <jan.kiszka@siemens.com>
> ---
>  arch/x86/kvm/x86.c |   20 ++++++++++++--------
>  1 files changed, 12 insertions(+), 8 deletions(-)

Applied, thanks.

