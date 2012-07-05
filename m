Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933049Ab2GEN0h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 09:26:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61103 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932483Ab2GEN0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 09:26:34 -0400
Message-ID: <4FF59606.4060504@redhat.com>
Date: Thu, 05 Jul 2012 16:26:30 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Prarit Bhargava <prarit@redhat.com>
CC: linux-kernel@vger.kernel.org, Gleb Natapov <gleb@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH 1/2] kvm, Add x86_hyper_kvm to complete detect_hypervisor_platform
 check [v2]
References: <1341493877-16622-1-git-send-email-prarit@redhat.com> <1341493877-16622-2-git-send-email-prarit@redhat.com>
In-Reply-To: <1341493877-16622-2-git-send-email-prarit@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2012 04:11 PM, Prarit Bhargava wrote:
> While debugging I noticed that unlike all the other hypervisor code in the
> kernel, kvm does not have an entry for x86_hyper which is used in
> detect_hypervisor_platform() which results in a nice printk in the
> syslog.  This is only really a stub function but it
> does make kvm more consistent with the other hypervisors.
> 
> [v2]: add detect and _GPL export
> 

Please copy at least kvm@vger.kernel.org, and preferably Marcelo as well
(the other kvm co-maintainer).



-- 
error compiling committee.c: too many arguments to function


