Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695Ab1EPVxL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 17:53:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33109 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756207Ab1EPVxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 17:53:10 -0400
Message-ID: <4DD19C81.8000902@zytor.com>
Date: Mon, 16 May 2011 14:52:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Fenghua Yu <fenghua.yu@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Avi Kivity <avi@redhat.com>, Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/4] Enable SMEP CPU Feature
References: <1305581685-5144-1-git-send-email-fenghua.yu@intel.com>
In-Reply-To: <1305581685-5144-1-git-send-email-fenghua.yu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2011 02:34 PM, Fenghua Yu wrote:
> 
> Note: This patch set doesn't enable the SMEP feature in KVM. If it's needed,
> another patch will be pushed for enabling the feature in KVM.
> 

Hi Avi,

Could you comment on if this needs to be a gating factor?

	-hpa
