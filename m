Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759208Ab2HHUE6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 16:04:58 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63600 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553Ab2HHUE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 16:04:57 -0400
Subject: Re: NULL pointer dereference in selinux_ip_postroute_compat
From: Eric Dumazet <eric.dumazet@gmail.com>
To: John Stultz <johnstul@us.ibm.com>
Cc: Paul Moore <paul@paul-moore.com>, "Serge E. Hallyn" <serge@hallyn.com>,
        lkml <linux-kernel@vger.kernel.org>,
        James Morris <james.l.morris@oracle.com>, selinux@tycho.nsa.gov,
        Eric Dumazet <edumazet@google.com>, john.johansen@canonical.com
In-Reply-To: <5022C2D5.3050208@us.ibm.com>
References: <50215A7E.8000701@linaro.org> <502198B4.8040503@linaro.org>
	 <5022BAA2.90606@us.ibm.com>  <17464273.DGOeQvDGIE@sifl>
	 <1344454701.28967.233.camel@edumazet-glaptop> <5022C2D5.3050208@us.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Aug 2012 22:04:52 +0200
Message-ID: <1344456292.28967.239.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-08 at 12:49 -0700, John Stultz wrote:

> I can't comment on the patch itself, but I tested it against Linus' HEAD 
> and it seems to resolve the oops on shutdown for me.

OK, thanks !



