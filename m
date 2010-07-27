Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404Ab0G0THm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 15:07:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41825 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195Ab0G0THl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 15:07:41 -0400
Message-ID: <4C4F2E74.3000608@redhat.com>
Date: Tue, 27 Jul 2010 22:07:32 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: SVM: Sync efer back into nested vmcb
References: <1280247261-19115-1-git-send-email-joerg.roedel@amd.com> <1280247261-19115-2-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1280247261-19115-2-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 07/27/2010 07:14 PM, Joerg Roedel wrote:
> This patch fixes a bug in a nested hypervisor that heavily
> switches between real-mode and long-mode. The problem is
> fixed by syncing back efer into the guest vmcb on emulated
> vmexit.

This is vmware?  IIRC their old kernel was 32-bit, so they need to 
switch all the time.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

