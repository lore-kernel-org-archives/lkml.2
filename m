Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758967Ab2CITlX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:41:23 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:38637 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754819Ab2CITlW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:41:22 -0500
MIME-Version: 1.0
In-Reply-To: <20120307144643.GB2009@x61.redhat.com>
References: <20120305181041.GA9829@x61.redhat.com>
	<4F56ECE6.4010100@gmail.com>
	<alpine.DEB.2.00.1203062142290.6424@chino.kir.corp.google.com>
	<20120307144643.GB2009@x61.redhat.com>
Date: Fri, 9 Mar 2012 21:41:21 +0200
X-Google-Sender-Auth: iGZId69kW8CDav8zMm479GnZ0EM
Message-ID: <CAOJsxLFQjV1c7nQZMA2voybN0AdhGrKFN5svQHC2C=oP3vOD4g@mail.gmail.com>
Subject: Re: [PATCH -v2] mm: SLAB Out-of-memory diagnostics
From: Pekka Enberg <penberg@kernel.org>
To: Rafael Aquini <aquini@redhat.com>
Cc: David Rientjes <rientjes@google.com>, Cong Wang <xiyou.wangcong@gmail.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Christoph Lameter <cl@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>, Rik van Riel <riel@redhat.com>,
        Josef Bacik <josef@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 7, 2012 at 4:46 PM, Rafael Aquini <aquini@redhat.com> wrote:
>> > Nitpick:
>> >
>> > What about "node: 0" instead of "node0: " ?
>> >
>>
>> Good catch, that format would match the output of the slub out-of-memory
>> messages.
>>
>
> To be honest, I really don't see a big advantage on the nitpick, however, if we
> want to accurately copycat the slub output here, I can insert a blank space
> between the word and the digit, like the following:
>   "node #: ..."

So if you're interested in getting this patch to v3.4, now would be a
good time to update the patch as per review comments and resend.

                        Pekka
