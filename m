Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876Ab2DDCaR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 22:30:17 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:47723 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755447Ab2DDCaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 22:30:16 -0400
Date: Wed, 4 Apr 2012 02:30:33 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Kees Cook <keescook@chromium.org>
Cc: Phillip Lougher <plougher@redhat.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Richard Weinberger <richard@nod.at>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        "Serge E. Hallyn" <serge@hallyn.com>, Eugene Teo <eteo@redhat.com>,
        Eric Paris <eparis@redhat.com>, James Morris <jmorris@namei.org>
Subject: Re: [PATCH] sysctl: fix restrict write access to dmesg_restrict
Message-ID: <20120404023033.GB18730@mail.hallyn.com>
References: <20120330234317.GC411@lenovo-rd230-04.lab.bos.redhat.com>
 <CAGXu5jJhwy9=dmY_6WZWWxJ2MG2Vb2nwsh5zoQ3ocbvrt7HH0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJhwy9=dmY_6WZWWxJ2MG2Vb2nwsh5zoQ3ocbvrt7HH0w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Kees Cook (keescook@chromium.org):
> Actually, proc_dmesg_restrict is just a CAP_SYSADMIN-checking wrapper
> around proc_dointvec_minmax. Probably both dmesg_restrict and
> kptr_restrict should use it.

I've seen no more emails since this one.  Kees, do you want to send a
new patch?  (or has someone handled it?)

thanks,
-serge
