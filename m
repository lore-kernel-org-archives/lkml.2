Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706Ab2GAQoY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 12:44:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43358 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752498Ab2GAQoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 12:44:23 -0400
Message-ID: <4FF07E66.2020706@zytor.com>
Date: Sun, 01 Jul 2012 09:44:22 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: hacklu <embedway.linux@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86, boot: Optimize the elf header handling.
References: <4FB492F7.8050401@gmail.com> <87ipf9gtsb.fsf@xmission.com> <4FCAD590.8000506@zytor.com> <87obp0bxdv.fsf@xmission.com> <4FCB602B.70907@zytor.com> <87fwacb0jq.fsf_-_@xmission.com> <877gvob0g4.fsf_-_@xmission.com> <4FF06701.6010004@zytor.com> <4FF06DF4.4000006@zytor.com> <87wr2nsbvi.fsf@xmission.com> <4FF0769F.8090105@zytor.com> <87sjdbsb0v.fsf@xmission.com>
In-Reply-To: <87sjdbsb0v.fsf@xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2012 09:26 AM, Eric W. Biederman wrote:
>
> Fair enough.  It looks like somehow SMP got unset in my test
> configuration and enabling SMP certainly kills the boot for
> me.  So it looks like I can reproduce this.
>
> So I am guess I just missed something.  Ugh.
>
> Digging deeper...
>

Could there be a VMA/LMA confusion?  The VMA for the .data..percpu 
section is zero.

	-hpa



