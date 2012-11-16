Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751310Ab2KPHWL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 02:22:11 -0500
Received: from mx3-phx2.redhat.com ([209.132.183.24]:46206 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab2KPHWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 02:22:09 -0500
Date: Fri, 16 Nov 2012 02:21:43 -0500 (EST)
From: Tomas Hozza <thozza@redhat.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, olaf@aepfle.de,
        apw@canonical.com, jasowang@redhat.com, kys@microsoft.com
Message-ID: <281332898.21894.1353050503909.JavaMail.root@redhat.com>
In-Reply-To: <20121115233909.GA17580@kroah.com>
Subject: Re: [PATCH] tools: hv: Netlink source address validation allows DoS
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.34.4.165]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - FF3.0 (Linux)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> On Thu, Nov 08, 2012 at 10:53:29AM +0100, Tomas Hozza wrote:
> > The source code without this patch caused hypervkvpd to exit when
> > it processed
> > a spoofed Netlink packet which has been sent from an untrusted
> > local user.
> > Now Netlink messages with a non-zero nl_pid source address are
> > ignored
> > and a warning is printed into the syslog.
> > 
> > Signed-off-by: Tomas Hozza <thozza@redhat.com>
> > Acked-by:  K. Y. Srinivasan <kys@microsoft.com>
> > ---
> >  tools/hv/hv_kvp_daemon.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> > 
> > diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
> > index 13c2a14..c1d9102 100755
> 
> Why are you setting a .c file to executable permissions?  Something
> is really wrong here...

I'm sorry, this is a mistake and unfortunately I missed it.
Permissions should be 0644. Will check more carefully next time.

Regards,

Tomas Hozza
