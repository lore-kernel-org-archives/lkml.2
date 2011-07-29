Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483Ab1G2IVN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 04:21:13 -0400
Received: from tundra.namei.org ([65.99.196.166]:52726 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755097Ab1G2IVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 04:21:11 -0400
Date: Fri, 29 Jul 2011 18:17:31 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Vasiliy Kulikov <segoon@openwall.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        kernel-hardening@lists.openwall.com,
        Stephen Smalley <sds@tycho.nsa.gov>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Eric Paris <eparis@redhat.com>, Willy Tarreau <w@1wt.eu>,
        Sebastian Krahmer <krahmer@suse.de>
Subject: Re: [patch v3] move RLIMIT_NPROC check from set_user() to
 do_execve_common()
In-Reply-To: <20110729081156.GB2488@albatros>
Message-ID: <alpine.LRH.2.00.1107291815410.15102@tundra.namei.org>
References: <20110721124830.GA1325@openwall.com> <CA+55aFy4ybatb0McQr2f4A56ympZVLqK2sbp2=73idu58_4RxQ@mail.gmail.com> <20110721193939.GA3914@openwall.com> <20110725171423.GA3739@albatros> <20110725234013.GB24110@openwall.com> <20110726104713.37273143@notabene.brown>
 <20110726011629.GA24610@openwall.com> <20110726141118.32f948e0@notabene.brown> <20110726144848.GA7133@albatros> <20110729080613.GA2488@albatros> <20110729081156.GB2488@albatros>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jul 2011, Vasiliy Kulikov wrote:

> +	 * RLIMIT_NPROC limits on user->processes have already been checked
> +	 * in set_user().
>  	 */
> +
>  	alter_cred_subscribers(new, 2);

Please get rid of the extra blank line if you re-spin.


Reviewed-by: James Morris <jmorris@namei.org>



-- 
James Morris
<jmorris@namei.org>
