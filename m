Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239Ab1LGO0h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 09:26:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53788 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755818Ab1LGO0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 09:26:36 -0500
Message-ID: <4EDF7797.9080103@redhat.com>
Date: Wed, 07 Dec 2011 16:26:31 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: VMX: Notify if VMX is already in use
References: <1322764218-4698-1-git-send-email-levinsasha928@gmail.com>   <4EDF7590.5060701@redhat.com> <1323267521.4009.11.camel@lappy>  <4EDF76D6.7020800@redhat.com> <1323267891.4009.16.camel@lappy>
In-Reply-To: <1323267891.4009.16.camel@lappy>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2011 04:24 PM, Sasha Levin wrote:
> > 
> > That's odd.  IIRC when we discussed this with them, they were executing
> > VMXON/VMXOFF dynamically.  Looks like they changed this.
> > 
> > Anyway, please adjust according to Joerg's comment (and add the word
> > "using"), and I'll apply.
>
> I've seen it the day before I've sent those patches. vbox driver loaded,
> kvm silently failed and rdmsr showed SVME turned on.
>
> Will resend.

Ah, maybe they do it differently on AMD.  Or they changed things.

btw, was it really silent?  Didn't modprobe complain?

The patch makes sense in any case.

-- 
error compiling committee.c: too many arguments to function

