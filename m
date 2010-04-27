Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab0D0CVq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 22:21:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14934 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751622Ab0D0CVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 22:21:45 -0400
Message-ID: <4BD64A34.6010504@redhat.com>
Date: Mon, 26 Apr 2010 16:21:40 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com
Subject: Re: [PATCH 0/6] pvclock fixes
References: <1272303988-21929-1-git-send-email-glommer@redhat.com>
In-Reply-To: <1272303988-21929-1-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2010 07:46 AM, Glauber Costa wrote:
> Hi,
>
> This is the last series I've sent, with comments from you merged.
> The first 5 patches are the same, only with the suggested fixes.
> I am leaving documentation out, since the basics won't change, and
> we're still discussing the details.
>
> Patch 6 is new, and is the guest side of the skipping updates
> avi asked for. I haven't yet done any HV work on this
> (specially because I am not convinced exactly where it is safe to
> do).
>
> Let me know what you think.
>    

I'm rebasing my patches on top of this series to address the host side 
issues.  I noticed a couple issues patching against Avi's tree, not sure 
if those issues are also present in trunk.

Can you keep me CC'd on any updates to this series?

Thanks,

Zach
