Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757733Ab0FOSRS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 14:17:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36688 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755886Ab0FOSRR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 14:17:17 -0400
Message-ID: <4C17C396.2040002@zytor.com>
Date: Tue, 15 Jun 2010 11:16:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Hans Rosenfeld <hans.rosenfeld@amd.com>
CC: "mingo@redhat.com" <mingo@redhat.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] AMD errata checking framework
References: <1276262713-26864-1-git-send-email-hans.rosenfeld@amd.com> <4C129927.4060502@zytor.com> <20100614123342.GB746@escobedo.osrc.amd.com>
In-Reply-To: <20100614123342.GB746@escobedo.osrc.amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2010 05:33 AM, Hans Rosenfeld wrote:
> 
>> Also, the use of divide and modulo when shifts and masks work are
>> generally frowned upon in Linux as a matter of style.
> 
> While I agree in principle, I think that in this special case the
> divide and modulo by 64 make it easier to understand what the code
> does on the first look. But if you insist I will send another patch
> set that replaces divide and modulo with shifts and masks.
> 

I do insist.

	-hpa
