Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239Ab0HaLxV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 07:53:21 -0400
Received: from mother.openwall.net ([195.42.179.200]:55277 "HELO
	mother.openwall.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756812Ab0HaLxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 07:53:19 -0400
Date: Tue, 31 Aug 2010 15:53:04 +0400
From: Solar Designer <solar@openwall.com>
To: Brad Spengler <spender@grsecurity.net>
Cc: Roland McGrath <roland@redhat.com>, Kees Cook <kees.cook@canonical.com>,
        linux-kernel@vger.kernel.org, oss-security@lists.openwall.com,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Neil Horman <nhorman@tuxdriver.com>, linux-fsdevel@vger.kernel.org,
        pageexec@freemail.hu
Subject: Re: [PATCH] exec argument expansion can inappropriately trigger OOM-killer
Message-ID: <20100831115304.GA27486@openwall.com>
References: <20100827220258.GF4703@outflux.net> <20100830005648.431B7400D9@magilla.sf.frob.com> <20100830032331.GA22773@openwall.com> <20100830174920.GA25091@openwall.com> <20100830220847.GA24980@grsecurity.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100830220847.GA24980@grsecurity.net>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brad, Roland -

Thank you for your comments and your work on this.

On Mon, Aug 30, 2010 at 06:08:47PM -0400, Brad Spengler wrote:
> There shouldn't be any additional risk from adding the extra rescheds, 
> as copy_*_user can already sleep and be raced against via a number of 
> methods.

Agreed.

Alexander
