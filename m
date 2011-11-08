Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413Ab1KHWBx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 17:01:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55589 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752866Ab1KHWBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 17:01:52 -0500
Message-ID: <4EB9A6BC.7050600@zytor.com>
Date: Tue, 08 Nov 2011 14:01:32 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Daniel Drake <dsd@laptop.org>, linux-kernel@vger.kernel.org
Subject: Re: Geode LX boot fails after x86 microcode revision change
References: <CAMLZHHTSuHZoPbm_YfB8G05JA+xKCE4+Jmj4NW8mnZUHogQSBA@mail.gmail.com> <20111108203116.GF25083@aftab>
In-Reply-To: <20111108203116.GF25083@aftab>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2011 12:31 PM, Borislav Petkov wrote:
> 
> it might be that the Geode doesn't have the patch level MSR.., can you
> send /proc/cpuinfo from a working kernel please, say 3.1?
> 
> Although, I have rdmsr_safe in the patch there so it actually shouldn't
> be an issue, theoretically.
> 

rdmsr_safe() requires exception table support, may not be available yet.

	-hpa

