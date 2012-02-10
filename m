Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759527Ab2BJQKd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 11:10:33 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43157 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759478Ab2BJQKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 11:10:31 -0500
MIME-Version: 1.0
In-Reply-To: <4F34D292.4080404@redhat.com>
References: <20120209202938.GA14342@linux.intel.com> <CA+55aFw1=2SR3CtDU_1F_9QJ8OpdGyRRWMbrbvT+COpLWMNO+A@mail.gmail.com>
 <20120209210039.GB14342@linux.intel.com> <4F34D292.4080404@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 10 Feb 2012 08:10:11 -0800
X-Google-Sender-Auth: c7rtSa7puDXD_5zA0OESsManZkc
Message-ID: <CA+55aFwpDdswAGdAvQs-ud+jjvtNeBCiCYmaZAYwnNpQLTYRkg@mail.gmail.com>
Subject: Re: scsi_id: sending ioctl 2285 to a partition
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Matthew Wilcox <willy@linux.intel.com>, linux-kernel@vger.kernel.org,
        Doug Nelson <doug.nelson@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 10, 2012 at 12:17 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> At the time the printk is removed, access also will be disallowed to root.

Well, that's clearly not going to be the case, since the printk is
finding way more cases than the initial expectation was.

                      Linus
