Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757646Ab0EFLmj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 07:42:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48669 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756767Ab0EFLmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 07:42:38 -0400
Message-ID: <4BE2AB2B.5040107@redhat.com>
Date: Thu, 06 May 2010 14:42:35 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
CC: "Przywara, Andre" <Andre.Przywara@amd.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] KVM: SVM: Allow EFER.LMSLE to be set with nested
 svm
References: <1273068285-3105-1-git-send-email-joerg.roedel@amd.com> <1273068285-3105-5-git-send-email-joerg.roedel@amd.com> <4BE184E3.1010508@redhat.com> <4BE1DB9C.7000405@amd.com> <20100506093842.GE7515@amd.com>
In-Reply-To: <20100506093842.GE7515@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2010 12:38 PM, Roedel, Joerg wrote:
> Subject: [PATCH] KVM: X86: Inject #GP with the right rip on efer writes
> This patch fixes a bug in the KVM efer-msr write path. If a
> guest writes to a reserved efer bit the set_efer function
> injects the #GP directly. The architecture dependent wrmsr
> function does not see this, assumes success and advances the
> rip. This results in a #GP in the guest with the wrong rip.
> This patch fixes this by reporting efer write errors back to
> the architectural wrmsr function.
>    

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function

