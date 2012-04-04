Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852Ab2DDVU5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 17:20:57 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:65113 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905Ab2DDVU4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 17:20:56 -0400
MIME-Version: 1.0
In-Reply-To: <CAFLxGvzVccmuUKpbdqWfi+JEsgk2X59hK=C7RWY2q5+a2JjR2g@mail.gmail.com>
References: <1333569554.864.3.camel@mop> <20120404210507.GA1716@kroah.com> <CAFLxGvzVccmuUKpbdqWfi+JEsgk2X59hK=C7RWY2q5+a2JjR2g@mail.gmail.com>
From: Kay Sievers <kay@vrfy.org>
Date: Wed, 4 Apr 2012 23:20:35 +0200
Message-ID: <CAPXgP10f_jYUvLgE+XS9CBOxL32fzxLWef57hSjAAp_K71hRBQ@mail.gmail.com>
Subject: Re: [PATCH] printk: support structured and multi-facility log messages
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Greg Kroah-Hartmann <greg@kroah.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 4, 2012 at 23:16, richard -rw- weinberger
<richard.weinberger@gmail.com> wrote:
> On Wed, Apr 4, 2012 at 11:05 PM, Greg Kroah-Hartmann <greg@kroah.com> wrote:
>> I just noticed that 'tail -f' doesn't seem to work on /dev/kmsg, should
>> it?  Or does it need to do something else to get "just the new ones"?
>>
>
> AFAIK tail looks at the file size/timestamp to detect modifications...

It uses inotify when available, these days.

Kay
