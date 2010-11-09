Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438Ab0KIMLQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 07:11:16 -0500
Received: from mx1.vsecurity.com ([209.67.252.12]:63122 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754822Ab0KIMLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 07:11:15 -0500
Subject: Re: [PATCH] Restrict unprivileged access to kernel syslog
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, security@kernel.org, stable@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <20101109112350.GA29800@elte.hu>
References: <1289273338.6287.128.camel@dan> <20101109112350.GA29800@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Nov 2010 07:11:12 -0500
Message-ID: <1289304672.6287.132.camel@dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> The initialization to zero is implicit, no need to write it out.
> 

I'll resend after the first round of comments.

> Also, it would also be useful to have a CONFIG_SECURITY_RESTRICT_DMESG=y option 
> introduced by your patch as well, which flag allows a distro or user to disable 
> unprivileged syslog reading via the kernel config.

Are you suggesting having the existence of the sysctl depend on
CONFIG_SECURITY_RESTRICT_DMESG, or having a choice between a sysctl
(when config is disabled) and having restrictions always on (when config
is enabled)?

-Dan

