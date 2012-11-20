Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab2KTOu3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 09:50:29 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:59183 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab2KTOu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 09:50:28 -0500
MIME-Version: 1.0
In-Reply-To: <20121120144742.GG7955@dm>
References: <1353190818-10070-1-git-send-email-const@MakeLinux.com>
	<20121120142906.GD7955@dm>
	<1353422629.11235.10.camel@joe-AO722>
	<20121120144742.GG7955@dm>
Date: Tue, 20 Nov 2012 16:50:27 +0200
X-Google-Sender-Auth: MdCALoFepm75oZ-VbW51NTKhkLk
Message-ID: <CAE7jHC8LsxPaQHqy5-H4-wZp6q+_0s7arnPa3jG7R9x=tf_Oww@mail.gmail.com>
Subject: Re: [PATCH v4] checkpatch: debugfs_remove() can take NULL
From: Constantine Shulyupin <const@makelinux.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> On Tue, 2012-11-20 at 14:29 +0000, Andy Whitcroft wrote:
>> Perhaps just
>>                               WARN("NEEDLESS_IF",
>
> I would cirtainly be happy with that, I was trying to avoid changing the
> capacity for the existing NEEDLESS_KFREE.  If compatibility there isn't
> an issue then that makes life even simpler.
>
> -apw

Right.
