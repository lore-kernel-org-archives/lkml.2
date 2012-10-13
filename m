Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100Ab2JMCQ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 22:16:56 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:54274 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947Ab2JMCQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 22:16:55 -0400
MIME-Version: 1.0
In-Reply-To: <20121012134529.GA1560@phenom.dumpdata.com>
References: <20121012134529.GA1560@phenom.dumpdata.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 13 Oct 2012 11:16:34 +0900
X-Google-Sender-Auth: 2HqzI1SK8hCBG-Ykfx9xpSR-QAY
Message-ID: <CA+55aFzfmJNTtrnRsEkb6B0=eTHNGuA+jBa1METOK3ycxNsM8g@mail.gmail.com>
Subject: Re: [GIT PULL] (xen) stable/for-linus-3.7-uapi-tag for v3.7-rc0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2012 at 10:45 PM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
>
> Please pull!

Btw, please use the -M switch to get renames as renames (and
--summary). You diffstat:

>  include/uapi/xen/Kbuild    |    2 +
>  include/uapi/xen/evtchn.h  |   88 +++++++++++++++++++++++++++++++++++++++
>  include/uapi/xen/privcmd.h |   98 ++++++++++++++++++++++++++++++++++++++++++++
>  include/xen/Kbuild         |    2 -
>  include/xen/evtchn.h       |   88 ---------------------------------------
>  include/xen/privcmd.h      |   98 --------------------------------------------
>  6 files changed, 188 insertions(+), 188 deletions(-)

is misleading, the correct one is much simpler:

 include/{ => uapi}/xen/evtchn.h  | 0
 include/{ => uapi}/xen/privcmd.h | 0
 include/xen/Kbuild               | 2 --
 4 files changed, 2 insertions(+), 2 deletions(-)
 rename include/{ => uapi}/xen/evtchn.h (100%)
 rename include/{ => uapi}/xen/privcmd.h (100%)

Thanks,

                Linus
