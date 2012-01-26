Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908Ab2AZWMY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 17:12:24 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:62532 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752697Ab2AZWMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 17:12:22 -0500
MIME-Version: 1.0
In-Reply-To: <58311.79.160.186.248.1327615864.squirrel@www.nlc.no>
References: <CAFLxGvw85fWdsAodBn1Z0vFYZx0U+vYg6hgsBYbmfuyaFTgznA@mail.gmail.com>
	<58311.79.160.186.248.1327615864.squirrel@www.nlc.no>
Date: Thu, 26 Jan 2012 23:12:22 +0100
Message-ID: <CAFLxGvzsg71gtyPEtOAVnS-DtozYzqgoGNK-ZJRvBfq1mf3Oug@mail.gmail.com>
Subject: Re: [uml-devel] /sys/class/tty/tty0/active?
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: stian@nixia.no
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>, Greg KH <gregkh@suse.de>,
        user-mode-linux-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 26, 2012 at 11:11 PM,  <stian@nixia.no> wrote:
>> Hi!
>>
>> systemd goes nuts on UML.
>> While hunting down all issues I found out that systemd wants to read from
>> /sys/class/tty/tty0/active.
>
> Kernel version?

Linus' tree as of today.

-- 
Thanks,
//richard
