Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511Ab2BPQKR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 11:10:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752349Ab2BPQKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 11:10:14 -0500
Message-ID: <4F3D2A3C.9060902@redhat.com>
Date: Thu, 16 Feb 2012 18:09:32 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Danny Kukawka <danny.kukawka@bisect.de>
CC: Danny Kukawka <dkukawka@suse.de>, Marcelo Tosatti <mtosatti@redhat.com>,
        Alexander Graf <agraf@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch/powerpc/kvm/book3s_hv.c: included linux/sched.h
 twice
References: <1329400554-31904-1-git-send-email-danny.kukawka@bisect.de>
In-Reply-To: <1329400554-31904-1-git-send-email-danny.kukawka@bisect.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2012 03:55 PM, Danny Kukawka wrote:
> arch/powerpc/kvm/book3s_hv.c: included 'linux/sched.h' twice,
> remove the duplicate.
>

Thanks, applied.

-- 
error compiling committee.c: too many arguments to function

