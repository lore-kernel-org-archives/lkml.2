Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab1EBAEN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 20:04:13 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46316 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453Ab1EBAEJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 20:04:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=OePdSIUmC8GfmyeN0BJNStd93Be/XKHK2MVBa+GN9JQF6lsliQaqwDTbMXgnkTI7lF
         oLBF59aT5GWKSPFfTmC/iY1ZxD7cfbGIkL6IEdjAIft2wZkhfijmQB/F0ZGr3w9o7+Ba
         97mZX3d2xvhoOISharSrzJF3c2lhurNHdofo0=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=JzmOm+Sm+xnY+rT-r8EwxQXO-xw@mail.gmail.com>
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
 <m1zkn68mpk.fsf@fess.ebiederm.org> <BANLkTi=NcpPQUGkR=pbOMPfMkyL7LiBeoA@mail.gmail.com>
 <m1r58i2g02.fsf@fess.ebiederm.org> <BANLkTi=JzmOm+Sm+xnY+rT-r8EwxQXO-xw@mail.gmail.com>
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Date: Mon, 2 May 2011 02:03:48 +0200
Message-ID: <BANLkTi=yhhnx=c2GRxMfBzoZk7eWeOiTZA@mail.gmail.com>
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

On Mon, May 2, 2011 at 1:34 AM, Lucian Adrian Grijincu
<lucian.grijincu@gmail.com> wrote:
> Regarding that: I'm now trying to reproduce a NULL access in
> sysctl_is_seen that I got only once. It's coupled with a
> "rcu_sched_state stall detected" warning from RCU.


Disregard that, I...

PEBKAC. I thought it was produced in a unpatched 2.6.39-rc5, but it
happened in one that I messed up.

-- 
 .
..: Lucian
