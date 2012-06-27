Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355Ab2F0Xzl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 19:55:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21838 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751910Ab2F0Xzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 19:55:40 -0400
Message-ID: <4FEB9D7B.7050001@redhat.com>
Date: Wed, 27 Jun 2012 19:55:39 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Prarit Bhargava <prarit@redhat.com>
CC: linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Gleb Natapov <gleb@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH] kvm, Add x86_hyper_kvm to complete detect_hypervisor_platform
 check
References: <1340833338-15485-1-git-send-email-prarit@redhat.com>
In-Reply-To: <1340833338-15485-1-git-send-email-prarit@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/27/2012 05:42 PM, Prarit Bhargava wrote:
> While debugging I noticed that unlike all the other hypervisor code in the
> kernel, kvm does not have an entry for x86_hyper which is used in
> detect_hypervisor_platform(), and results in a nice message about the
> hypervisor being used.  This is only really a stub function and it makes
> kvm more consistent with the other hypervisors (and it makes debugging
> a little easier).
> 
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
> Cc: Avi Kivity <avi@redhat.com>
> Cc: Gleb Natapov <gleb@redhat.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>

Self - nak this ... new patch coming.  Sorry for the noise.

P.
