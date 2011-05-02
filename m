Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101Ab1EBHoc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 03:44:32 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46558 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754602Ab1EBHo2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 03:44:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=J10EIFOntgn6fC30Us7/1pONLcHlwmqMlusPMAUUIxHGBVoL1ompyt5a2inixqehRu
         Ndt2oPziL/+TjeyWIrDNc4xGdyMuS+o4E/IMVHczARwNIfsGH0wx5HgKV/LAOxUpAZ4Q
         vBdxopmbRzB5BHxA5vhmItI0nlBr0mdmkz4Tw=
MIME-Version: 1.0
In-Reply-To: <m1aaf5yf64.fsf@fess.ebiederm.org>
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
 <m1zkn68mpk.fsf@fess.ebiederm.org> <BANLkTi=NcpPQUGkR=pbOMPfMkyL7LiBeoA@mail.gmail.com>
 <m1r58i2g02.fsf@fess.ebiederm.org> <BANLkTinTMckhNYx1OiyH_YR+hr31naPQHw@mail.gmail.com>
 <m1aaf5yf64.fsf@fess.ebiederm.org>
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Date: Mon, 2 May 2011 09:44:05 +0200
Message-ID: <BANLkTi=PazFJ2QAXArCK52X7JM-xq5Ca5w@mail.gmail.com>
Subject: Re: [PATCH 00/69] faster tree-based sysctl implementation
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
        Octavian Purdila <tavi@cs.pub.ro>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 2, 2011 at 5:06 AM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> In particular I was referring to create_proc_entry.  It takes
> a path and an optional parent directory.

I did something like that in this patch series I sent a month ago
which was mostly ignored (except for a call from David Miller for
feedback on the patches):
http://thread.gmane.org/gmane.linux.kernel/1121889

I'll see how I can add the optional parent directory in this patch series.

Could you please take a look at a few patches in the above series?

The ones that have "cookie:" add a cookie pointer to the
ctl_table_header making it possible to skip duplicating ctl_table
arrays in a few places in the kernel. After finishing this series I'll
send one with the cookie..

-- 
 .
..: Lucian
