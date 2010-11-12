Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636Ab0KLKWv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 05:22:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:55439 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752711Ab0KLKWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 05:22:50 -0500
Message-ID: <4CDD1556.4010109@kernel.org>
Date: Fri, 12 Nov 2010 11:22:14 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH UPDATED 4/9] x86: Initialize 32bit logical apicid mapping
 early during boot
References: <1289473363-29440-1-git-send-email-tj@kernel.org> <1289473363-29440-5-git-send-email-tj@kernel.org> <4CDD0B1F.4060701@kernel.org> <4CDD0FD0.1020807@kernel.org>
In-Reply-To: <4CDD0FD0.1020807@kernel.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 12 Nov 2010 10:22:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2010 10:58 AM, Yinghai Lu wrote:
> those replacing smp_processor_id() with cpu should be in another patch.

It's a mechanical cleanup.  I can add 'while at it, ...' to the patch
description.  Oh well, what the hell, I'll split it.

Thanks.

-- 
tejun
