Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984Ab1FGH6g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 03:58:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33642 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647Ab1FGH6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 03:58:35 -0400
Message-ID: <4DEDDA10.1080603@redhat.com>
Date: Tue, 07 Jun 2011 10:58:08 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Marcelo Tosatti <mtosatti@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Subject: Re: [PATCH] kvm: Fix build warnings
References: <20110530124600.GB494@eferding.osrc.amd.com> <1306786278-12219-1-git-send-email-bp@alien8.de> <20110531073824.GA17999@elte.hu> <4DE4A4E7.80503@redhat.com> <20110531102655.GC24172@elte.hu> <20110607072813.GC21263@liondog.tnic>
In-Reply-To: <20110607072813.GC21263@liondog.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2011 10:28 AM, Borislav Petkov wrote:
> So, any progress on this front? Warning is still there in -rc2.
>

Thanks for the reminder, applied and queued.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

