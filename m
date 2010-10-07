Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760213Ab0JGJx2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 05:53:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58255 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753695Ab0JGJx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 05:53:27 -0400
Message-ID: <4CAD9876.3030500@redhat.com>
Date: Thu, 07 Oct 2010 11:52:54 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        hpa@zytor.com, riel@redhat.com, cl@linux-foundation.org,
        mtosatti@redhat.com
Subject: Re: [PATCH v6 02/12] Halt vcpu if page it tries to access is swapped
 out.
References: <1286207794-16120-1-git-send-email-gleb@redhat.com> <1286207794-16120-3-git-send-email-gleb@redhat.com> <4CAD97D0.70100@redhat.com>
In-Reply-To: <4CAD97D0.70100@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 10/07/2010 11:50 AM, Avi Kivity wrote:
>
> I missed where you halt the vcpu.  Can you point me at the function?

Found it.

Multiplexing a guest state with a host state is a bad idea.  Better have 
separate state.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

