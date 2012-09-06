Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933117Ab2IFUty (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 16:49:54 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:54247 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932872Ab2IFUtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 16:49:52 -0400
Message-ID: <50490C6C.9060608@redhat.com>
Date: Thu, 06 Sep 2012 22:49:48 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
CC: linux-kernel@vger.kernel.org, target-devel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC PATCH 0/3] target: try satisfying memory requests with higher-order
 allocations
References: <1346858025-10459-1-git-send-email-pbonzini@redhat.com>  <1346896698.4162.403.camel@haakon2.linux-iscsi.org>  <50486727.7060509@redhat.com> <1346957579.4162.504.camel@haakon2.linux-iscsi.org>
In-Reply-To: <1346957579.4162.504.camel@haakon2.linux-iscsi.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 06/09/2012 20:52, Nicholas A. Bellinger ha scritto:
> That way we can just disable a problematic fabric instead of having to
> revert the whole thing if users run into problems with a specific fabric
> module late during the cycle.  If the other fabric maintainers are OK
> with enabling this in their code and give their Reviewed-By's +
> Tested-By's, then I have no problem dropping this extra bit once
> everything has been converted.

Fair enough.

> Mmmmm, indeed.  Also, I'm not sure that every old SCSI LLD is smart
> enough to handle high older allocations -> multi-page SGLs either..

If not, they should simply set max_segment_size to 4096.

Paolo

