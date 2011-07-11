Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758353Ab1GKRpc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 13:45:32 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:39585 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758336Ab1GKRpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 13:45:30 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=IjdV9TBXer+4/g3eqLp8by3v32mUq7cIr5QOntjgijDVWT0XL33WjkLik1WLuzW1n+uRnaRv4RcbtQBOKaTeMQ2OcFh8vr5Qa9pK72jDp+CZJSd2X8jYryfNwccYkZcl;
Date: Mon, 11 Jul 2011 10:45:28 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Paul Menage <menage@google.com>
Cc: Wanlong Gao <wanlong.gao@gmail.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: Re: [PATCH] Doc:cgroup:fix a cpuset's file description in
 cpusets.txt
Message-Id: <20110711104528.33240c46.rdunlap@xenotime.net>
In-Reply-To: <CAJniumXsZ=DDBHxp_RtdhcZ0n8efdyjSZCERn8H1H3G3AnCf2w@mail.gmail.com>
References: <1310288313-4908-1-git-send-email-wanlong.gao@gmail.com>
	<CAJniumXsZ=DDBHxp_RtdhcZ0n8efdyjSZCERn8H1H3G3AnCf2w@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jul 2011 10:23:53 -0700 Paul Menage wrote:

> On Sun, Jul 10, 2011 at 1:58 AM, Wanlong Gao <wanlong.gao@gmail.com> wrote:
> > Only the root cpuset has cpuset.memory_pressure_enabled flag,
> > but not the only one.
> >
> > Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
> 
> Acked-by: Paul Menage <menage@google.com>

Thanks.

> The original was actually correct English, when parsed as "(the root
> cpuset only) (has the following file)", but I guess ambiguous. I'd be
> inclined to just remove the word "only", since it's unnecessary in its
> new location.

Yes, it's ambiguous and/or too restrictive.
Yes, we could just drop the word "only".

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
