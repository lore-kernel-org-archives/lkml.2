Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab0HTNxt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 09:53:49 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:45637 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600Ab0HTNxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 09:53:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=GAPEVb0CXGZ5WvY+TfnV3LDNcroYNfehubmD7h2+9n5EJMU7fsNd8rizVfqoyMcq2t
         cG7YyqLzwr6IUkHzF5h78T1SwpPhhG80yjB6kXh/dSv664a1lH1rro7UKIYtVAKZVDR0
         OjJn13DeC42feQah58jVxYOdb5VZvK4NP5ROo=
Message-ID: <4C6E8925.10603@lwfinger.net>
Date: Fri, 20 Aug 2010 08:54:45 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: Regression in 2.6.36-rc1 bisected to commit 9d8888c
References: <4C6DE7E3.4030702@lwfinger.net> <20100820075125.GA23650@aftab>
In-Reply-To: <20100820075125.GA23650@aftab>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2010 02:51 AM, Borislav Petkov wrote:
> From: Larry Finger <Larry.Finger@lwfinger.net>
> Date: Thu, Aug 19, 2010 at 09:26:43PM -0500
> 
>> With 2.6.36-rc1 from the mainline git tree, my x86_64 system running on an AMD
>> Turion 64 x2 TL-60 has required pressing keys to get booting to advance. This
>> behavior begins as soon as the kernel is loaded. I bisected the problem to:
>>
>> commit 9d8888c2a214aece2494a49e699a097c2ba9498b
--snip--
>>
>> This problem is entered into the Kernel Bugzilla as Bug #16636.
> 
> Fix is already upstream: http://git.kernel.org/tip/07a7795ca2e6e66d00b184efb46bd0e23d90d3fe
> 
> Can you verify it fixes your issue too please?

Yes, it does fix my issue. I will note that a patch is available on the Bug report.

Thanks,

Larry
