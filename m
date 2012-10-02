Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785Ab2JBNs6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 09:48:58 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:44030 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753640Ab2JBNs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 09:48:57 -0400
Message-ID: <1349185736.7740.33.camel@joe-AO722>
Subject: Re: [PATCH RFC] MAINTAINERS: Add section for subsystem shortname
From: Joe Perches <joe@perches.com>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: Ezequiel Garcia <elezegarcia@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, gregkh@linuxfoundation.org,
        davem@davemloft.net, arnd@arndb.de, Julia.Lawall@lip6.fr,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Date: Tue, 02 Oct 2012 06:48:56 -0700
In-Reply-To: <CA+MoWDrMbkZYnRpEp5bAivZohVnZ4xPG0v3Wr_0ks_myzhCBDg@mail.gmail.com>
References: <1349179024-5319-1-git-send-email-peter.senna@gmail.com>
	 <20121002121443.GT4587@mwanda>
	 <CA+MoWDqxXPiuFwmznynn8SPK20eJUgCKonq+C=s8fKvcnkb4Aw@mail.gmail.com>
	 <CALF0-+W25fAD0=kLD085G+H1b-WFaARudo-hkJO_LoBTNZC-Nw@mail.gmail.com>
	 <CA+MoWDoy+cqkzDHmR2=-3UhMn-i+fU0RVKwtkcsgRxOBk98oYA@mail.gmail.com>
	 <CALF0-+WcUzsQ3b3gyCoauAYmmV3xDT7H1veKkabhvC8hofCWAA@mail.gmail.com>
	 <CA+MoWDrMbkZYnRpEp5bAivZohVnZ4xPG0v3Wr_0ks_myzhCBDg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-02 at 15:13 +0200, Peter Senna Tschudin wrote:
> On Tue, Oct 2, 2012 at 3:08 PM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
> > Just looking through media list I can spot lots of different subject schemes:
> >   [media] foo: fix some bug
> >   media: foo: fix some bug
> >   foo: fix some bug
> >   Some random text and fix some bug
> 
> According to:
> 
> http://yarchive.net/comp/linux/commit_messages.html
> 
> the subsystem short name is also important for whom is not working
> directly on that subsystem but may receive the E-mail with the
> patch...

Thread from awhile ago:
https://lkml.org/lkml/2010/11/16/245


