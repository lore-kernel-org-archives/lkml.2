Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600Ab2JEPde (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 11:33:34 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:50288 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756151Ab2JEPda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 11:33:30 -0400
Message-ID: <1349451208.2008.74.camel@joe-AO722>
Subject: Re: tty_init_dev: 24 callbacks suppressed
From: Joe Perches <joe@perches.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Borislav Petkov <bp@amd64.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 05 Oct 2012 08:33:28 -0700
In-Reply-To: <506EC1AE.6000201@suse.cz>
References: <20121004092055.GA21028@aftab.osrc.amd.com>
	 <20121004112347.GA245@x4> <20121004115157.GA245@x4>
	 <20121004124025.GC21028@aftab.osrc.amd.com> <20121004131101.GA245@x4>
	 <506EC1AE.6000201@suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-05 at 13:17 +0200, Jiri Slaby wrote:
> CCing Joe.
[]
> > I'll let Jiri handle this :). It's his patch anyway.
> 
> Actually this is Joe's version of the patch. Joe, people started hitting
> the bug [1]. Could you resend your patch?

> [1] https://patchwork.kernel.org/patch/1339221/

Markus already did that.

I think it'd be fine if someone picked it up.

> BTW what scares me that nobody noticed that bug until this is in the
> Linus's tree. Do people use -next at all or am I the only one user? (I
> didn't hit it as I have the patch in my local queue.)

I think you're the only actual user.

Does anyone else really use it as more than a tree
integration compilation testbed?


