Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab1AaLKm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 06:10:42 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48156 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab1AaLKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 06:10:41 -0500
Subject: Re: [PATCH v2 4/6] KVM-GST: KVM Steal time registration
From: Peter Zijlstra <peterz@infradead.org>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, aliguori@us.ibm.com,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Avi Kivity <avi@redhat.com>
In-Reply-To: <1296244340-15173-5-git-send-email-glommer@redhat.com>
References: <1296244340-15173-1-git-send-email-glommer@redhat.com>
	 <1296244340-15173-5-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 Jan 2011 12:11:37 +0100
Message-ID: <1296472297.15234.368.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-28 at 14:52 -0500, Glauber Costa wrote:
> +       /*
> +        * using nanoseconds introduces noise, which accumulates easily
> +        * leading to big steal time values. We want, however, to keep the
> +        * interface nanosecond-based for future-proofness. The hypervisor may
> +        * adopt a similar strategy, but we can't rely on that.
> +        */
> +       delta /= NSEC_PER_MSEC;
> +       delta *= NSEC_PER_MSEC; 

I really doubt that claim..

