Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615Ab0DLK2j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 06:28:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28224 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752824Ab0DLK2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 06:28:37 -0400
Message-ID: <4BC2F5D0.4090902@redhat.com>
Date: Mon, 12 Apr 2010 13:28:32 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: wzt.wzt@gmail.com
CC: linux-kernel@vger.kernel.org, mtosatti@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: Enhance the coalesced_mmio_write() parameter to
 avoid stack buffer overflow
References: <20100412015714.GA2815@localhost.localdomain>
In-Reply-To: <20100412015714.GA2815@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2010 04:57 AM, wzt.wzt@gmail.com wrote:
> coalesced_mmio_write() is not check the len value, if len is negative,
> memcpy(ring->coalesced_mmio[ring->last].data, val, len); will cause
> stack buffer overflow.
>
>    

How can len be negative?  It can only be between 1 and 8.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

