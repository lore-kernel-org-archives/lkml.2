Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab2KTO6X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 09:58:23 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:38966 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752411Ab2KTO6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 09:58:22 -0500
Message-ID: <1353423503.11235.12.camel@joe-AO722>
Subject: Re: [PATCH v4] checkpatch: debugfs_remove() can take NULL
From: Joe Perches <joe@perches.com>
To: Constantine Shulyupin <const@makelinux.com>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Date: Tue, 20 Nov 2012 06:58:23 -0800
In-Reply-To: <CAE7jHC8LsxPaQHqy5-H4-wZp6q+_0s7arnPa3jG7R9x=tf_Oww@mail.gmail.com>
References: <1353190818-10070-1-git-send-email-const@MakeLinux.com>
	 <20121120142906.GD7955@dm> <1353422629.11235.10.camel@joe-AO722>
	 <20121120144742.GG7955@dm>
	 <CAE7jHC8LsxPaQHqy5-H4-wZp6q+_0s7arnPa3jG7R9x=tf_Oww@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-11-20 at 16:50 +0200, Constantine Shulyupin wrote:
> >> On Tue, 2012-11-20 at 14:29 +0000, Andy Whitcroft wrote:
> >> Perhaps just
> >>                               WARN("NEEDLESS_IF",
> >
> > I would cirtainly be happy with that, I was trying to avoid changing the
> > capacity for the existing NEEDLESS_KFREE.  If compatibility there isn't
> > an issue then that makes life even simpler.
> >
> > -apw
> 
> Right.

I don't think it's an issue.  I'm not sure anyone
really uses --ignore for much other than LONG_LINE.




