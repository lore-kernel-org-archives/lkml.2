Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757647Ab1IATPr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 15:15:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35345 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757297Ab1IATPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 15:15:45 -0400
Subject: Re: [PATCH 09/24] C6X: signal management
From: Mark Salter <msalter@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        ming.lei@canonical.com, stern@rowland.harvard.edu
Date: Thu, 01 Sep 2011 15:15:38 -0400
In-Reply-To: <1314870603.8038.27.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1314826019-22330-1-git-send-email-msalter@redhat.com>
	 <1314826019-22330-10-git-send-email-msalter@redhat.com>
	 <1314870603.8038.27.camel@mfleming-mobl1.ger.corp.intel.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1314904539.1439.25.camel@deneb.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-01 at 10:50 +0100, Matt Fleming wrote:
> > +segv_and_exit:
> > +     force_sig(SIGSEGV, current);
> > +     return -EFAULT;
> > +}
> 
> Shouldn't that really be a call to force_sigsegv(signr, current) ?

Yes, I think so. Thanks.

--Mark


