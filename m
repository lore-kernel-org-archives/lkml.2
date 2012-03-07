Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab2CGKet (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 05:34:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43761 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753067Ab2CGKer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 05:34:47 -0500
Message-ID: <4F5739C3.5050600@redhat.com>
Date: Wed, 07 Mar 2012 12:34:43 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: dave@gnu.org
CC: Marcelo Tosatti <mtosatti@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH] kvm: mmu: make use of ->root_level in reset_rsvds_bits_mask
References: <1330962786.2953.1.camel@offbook>
In-Reply-To: <1330962786.2953.1.camel@offbook>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2012 05:53 PM, Davidlohr Bueso wrote:
> From: Davidlohr Bueso <dave@gnu.org>
>
> The reset_rsvds_bits_mask() function can use the guest walker's root level number
> instead of using a separate 'level' variable.
>

Thanks, applied.

-- 
error compiling committee.c: too many arguments to function

