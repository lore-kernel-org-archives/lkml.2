Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266Ab2KTPKt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 10:10:49 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36974 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696Ab2KTPKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 10:10:44 -0500
MIME-Version: 1.0
In-Reply-To: <1353423503.11235.12.camel@joe-AO722>
References: <1353190818-10070-1-git-send-email-const@MakeLinux.com>
	<20121120142906.GD7955@dm>
	<1353422629.11235.10.camel@joe-AO722>
	<20121120144742.GG7955@dm>
	<CAE7jHC8LsxPaQHqy5-H4-wZp6q+_0s7arnPa3jG7R9x=tf_Oww@mail.gmail.com>
	<1353423503.11235.12.camel@joe-AO722>
Date: Tue, 20 Nov 2012 17:10:43 +0200
X-Google-Sender-Auth: _JG64tv0ddcPTlG9JA4vb7KEi6I
Message-ID: <CAE7jHC-QqYCvSVR2JwCQjrSx6yH0-41GXfid6FSPP3xB8FV=2w@mail.gmail.com>
Subject: Re: [PATCH v4] checkpatch: debugfs_remove() can take NULL
From: Constantine Shulyupin <const@makelinux.com>
To: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 4:58 PM, Joe Perches <joe@perches.com> wrote:
> I don't think it's an issue.  I'm not sure anyone
> really uses --ignore for much other than LONG_LINE.

Indeed. Must all code be 80 characters width?  My be my be better to
make line length configurable than ignore it? Or at least print actual
line length to allow developer be aware how long lines is.
I think 90 char line is preferable than wrapped two or even three times line.

Thanks
