Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188Ab2IEOmm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 10:42:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21931 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978Ab2IEOml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 10:42:41 -0400
Message-ID: <504764DE.5080202@redhat.com>
Date: Wed, 05 Sep 2012 17:42:38 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: mst@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 0/2] kvm: level irqfd support
References: <20120821190800.24958.74812.stgit@bling.home>
In-Reply-To: <20120821190800.24958.74812.stgit@bling.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2012 10:28 PM, Alex Williamson wrote:
> Here's the much anticipated re-write of support for level irqfds.  As
> Michael suggested, I've rolled the eoi/ack notification fd into
> KVM_IRQFD as a new mode.  For lack of a better name, as there seems to
> be objections to associating this specifically with an EOI or an ACK,
> I've name this OADN or "On Ack, De-assert & Notify".

Perhaps we can call it "resample", since this is what it is doing.
irqfd tells kvm that the line as been asserted, resample tells the
caller to check again.

-- 
error compiling committee.c: too many arguments to function
