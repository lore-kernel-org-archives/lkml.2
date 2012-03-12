Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab2CLIWt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 04:22:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753743Ab2CLIWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 04:22:34 -0400
Message-ID: <4F5DB245.9060205@redhat.com>
Date: Mon, 12 Mar 2012 10:22:29 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: dave@gnu.org
CC: Marcelo Tosatti <mtosatti@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: VMX: add tracepoint for vpids
References: <1331481472.17316.1.camel@offbook>
In-Reply-To: <1331481472.17316.1.camel@offbook>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2012 05:57 PM, Davidlohr Bueso wrote:
> From: Davidlohr Bueso <dave@gnu.org>
>
> Add a new tracepoint for vpid allocation and freeing associated to all vCPUs.
>

Why?

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

