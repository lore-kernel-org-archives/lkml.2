Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957Ab2BJQZw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 11:25:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49461 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335Ab2BJQZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 11:25:51 -0500
Message-ID: <4F354508.8070209@redhat.com>
Date: Fri, 10 Feb 2012 17:25:44 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Matthew Wilcox <willy@linux.intel.com>, linux-kernel@vger.kernel.org,
        Doug Nelson <doug.nelson@intel.com>
Subject: Re: scsi_id: sending ioctl 2285 to a partition
References: <20120209202938.GA14342@linux.intel.com> <CA+55aFw1=2SR3CtDU_1F_9QJ8OpdGyRRWMbrbvT+COpLWMNO+A@mail.gmail.com> <20120209210039.GB14342@linux.intel.com> <4F34D292.4080404@redhat.com> <CA+55aFwpDdswAGdAvQs-ud+jjvtNeBCiCYmaZAYwnNpQLTYRkg@mail.gmail.com>
In-Reply-To: <CA+55aFwpDdswAGdAvQs-ud+jjvtNeBCiCYmaZAYwnNpQLTYRkg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2012 05:10 PM, Linus Torvalds wrote:
>> > At the time the printk is removed, access also will be disallowed to root.
> Well, that's clearly not going to be the case, since the printk is
> finding way more cases than the initial expectation was.

This is the only interesting case so far, i.e. the patch is actually 
changing the behavior (but it's still unclear why it happens; it may be 
misconfiguration or even fixing a bug).

That said, yeah, 1 _is_ way more than 0.

Paolo
