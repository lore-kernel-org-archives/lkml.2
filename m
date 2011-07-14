Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab1GNAOl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 20:14:41 -0400
Received: from tundra.namei.org ([65.99.196.166]:52541 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623Ab1GNAOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 20:14:40 -0400
Date: Thu, 14 Jul 2011 10:11:57 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: NeilBrown <neilb@suse.de>, Solar Designer <solar@openwall.com>,
        Vasiliy Kulikov <segoon@openwall.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        kernel-hardening@lists.openwall.com, Jiri Slaby <jslaby@suse.cz>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Eric Paris <eparis@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH] move RLIMIT_NPROC check from set_user() to
 do_execve_common()
In-Reply-To: <CA+55aFwQKqvNvzTMYXVW_yKkFtNsyv8uuBiWiwYLof-nPqPu9w@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.1107141009510.17067@tundra.namei.org>
References: <20110612130953.GA3709@albatros> <20110706173631.GA5431@albatros> <CA+55aFyfjG1h2zkkGai_VPM8p5bhWhvNXs1HvuWMgxv4RSywYw@mail.gmail.com> <20110706185932.GB3299@albatros> <20110707075610.GA3411@albatros> <20110707081930.GA4393@albatros>
 <20110712132723.GA3193@albatros> <CA+55aFysXOeBqEvmVbuqL3i0jRFDcE=vDuVhmYL38XQ0+x=deQ@mail.gmail.com> <20110713091408.0d456352@notabene.brown> <20110713063142.GA19976@openwall.com> <20110713170657.59dae548@notabene.brown>
 <CA+55aFwQKqvNvzTMYXVW_yKkFtNsyv8uuBiWiwYLof-nPqPu9w@mail.gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jul 2011, Linus Torvalds wrote:

> It sounds like people are effectively Ack'ing the patch, but with this
> kind of patch I don't want to add the "implicit Ack" that I often do
> for regular stuff.
> 
> So could people who think that the patch is ok in its current form
> just send me their acked-by or reviewed-by? I haven't heard any actual
> objection to it, and I think it's valid for the current -rc.
> 
> Alternatively, feel free to send a comment like "I think it's the
> right thing, but maybe it should wait for the next merge window"..

Count me in the latter.

It does look ok to me, but I'd be happier if it had more testing first (in 
-mm perhaps).  I think some security folk may be on summer vacation, too.


- James
-- 
James Morris
<jmorris@namei.org>
