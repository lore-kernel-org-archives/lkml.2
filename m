Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847Ab1HOKdK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 06:33:10 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39256 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab1HOKdI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 06:33:08 -0400
MIME-Version: 1.0
In-Reply-To: <bkwpSnItbJM.A.nx.VNCSOB@chimera>
References: <xuTC4jRtHbB.A.l4H.gMCSOB@chimera>
	<bkwpSnItbJM.A.nx.VNCSOB@chimera>
Date: Mon, 15 Aug 2011 13:33:07 +0300
X-Google-Sender-Auth: a4sEZaoENNvepZKeIJoqiBUkoIY
Message-ID: <CAOJsxLEToaQe3DrhUQx5FizMnzATxwG8XGCPwZpRFpuBQpq1ug@mail.gmail.com>
Subject: Re: [Bug #39412] Win Vista and Win2K8 guests' network breaks down
From: Pekka Enberg <penberg@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, Jay Ren <yongjie.ren@intel.com>,
        Avi Kivity <avi@redhat.com>, stefanha@linux.vnet.ibm.com,
        KVM General <kvm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 14, 2011 at 10:07 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.39 and 3.0.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.39 and 3.0.  Please verify if it still should
> be listed and let the tracking team know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=39412
> Subject         : Win Vista and Win2K8 guests' network breaks down
> Submitter       : Jay Ren <yongjie.ren@intel.com>
> Date            : 2011-07-15 15:31 (31 days old)

The bugzilla report claims that this commit fixes the regression:

http://git.kernel.org/?p=virt/kvm/kvm.git;a=commitdiff;h=e72ef590a3ef3047f6ed5bcb8808a9734f6c4b32

The commit, however, is not in mainline nor does it seem to be tagged
for -stable.
