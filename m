Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab1C2R1T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 13:27:19 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43827 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341Ab1C2R1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 13:27:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=l0TQl/9rFNkITV/pivkmHviKLNVDozrrwN5F+8p4avEiQQeR7HWRB0cOybAHUjvrmY
         69clBRO1f2y0NqxY9iYgKhMQ5ckZunTDJw4d+zbhE9d4/uZo33y/Z8hDsrU8C6gI0XYw
         l25JxN9axnkxMh1fqrd6pks7TN+sw59Fywo7Y=
MIME-Version: 1.0
In-Reply-To: <20110329121937.GA27497@redhat.com>
References: <1301346815-6755-1-git-send-email-roland@kernel.org> <20110329121937.GA27497@redhat.com>
From: Roland Dreier <roland@kernel.org>
Date: Tue, 29 Mar 2011 10:26:55 -0700
X-Google-Sender-Auth: -vtbzM8oDwsS2b6EdqyhbrE3BkY
Message-ID: <AANLkTimb+Kdf9KUNpvMA9qOEZWuPFLsLiwwqZB9M+Awn@mail.gmail.com>
Subject: Re: [PATCH v2] Relax si_code check in rt_sigqueueinfo and rt_tgsigqueueinfo
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Julien Tinnes <jln@google.com>,
        Klaus Dittrich <kladit@arcor.de>, Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 5:19 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> Thanks, I think -stable needs this patch asap. It turns out 2.6.32.36, 2.6.33.9,
> 2.6.37.6 and 2.6.38.2 pulled da48524eb20662618854bb3df2db01fc65f3070c.

Agree... the commit in Linus's tree is tagged for stable@.

The only issue I think is that Greg said he's not doing any more
2.6.37 releases?

Greg, this bug breaks the glibc test suite so maybe it's worth doing one more
release?
