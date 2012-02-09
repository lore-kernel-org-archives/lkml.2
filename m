Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758204Ab2BIVMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 16:12:19 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37900 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757902Ab2BIVMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 16:12:18 -0500
MIME-Version: 1.0
In-Reply-To: <20120209210039.GB14342@linux.intel.com>
References: <20120209202938.GA14342@linux.intel.com> <CA+55aFw1=2SR3CtDU_1F_9QJ8OpdGyRRWMbrbvT+COpLWMNO+A@mail.gmail.com>
 <20120209210039.GB14342@linux.intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 9 Feb 2012 13:11:58 -0800
X-Google-Sender-Auth: ERGEWjgG1LpHclE04rE8e8OuGAk
Message-ID: <CA+55aFwJe=+6M+0AnJ0=1Qy2V3pG=WD+LVbRV1ZC=0PyKNPbpg@mail.gmail.com>
Subject: Re: scsi_id: sending ioctl 2285 to a partition
To: Matthew Wilcox <willy@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Doug Nelson <doug.nelson@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 9, 2012 at 1:00 PM, Matthew Wilcox <willy@linux.intel.com> wrote:
>> And does it all work well apart from the printk? Because the printk
>> itself is scheduled to be removed, it's only there to hear about users
>> that may be doing crazy things that got disallowed by the patches in
>> question?
>
> If it is being run as root, then the printk is pointless, right?

No. The original patch actually disallowed it for everybody, including
root. The "let them through with a warning"

So part of the point of the printk was to see if these things happened
at all. We should have made the root'ness explicit in the printk,
though, to see that part too.

                 Linus
