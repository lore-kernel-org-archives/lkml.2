Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431Ab2LUQsJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 11:48:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36877 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897Ab2LUQr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 11:47:59 -0500
Message-ID: <50D49290.2030403@zytor.com>
Date: Fri, 21 Dec 2012 08:47:12 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Dave Young <hidave.darkstar@gmail.com>
CC: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Jacob Shin <jacob.shin@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 05/46] x86, mm: Revert back good_end setting for 64bit
References: <1354139277-17376-1-git-send-email-yinghai@kernel.org> <1354139277-17376-6-git-send-email-yinghai@kernel.org> <CABqxG0cFTu2qDo6RmZ7QfLsC4fDzLVj9WrocuDAz+dAQB8OJ6Q@mail.gmail.com>
In-Reply-To: <CABqxG0cFTu2qDo6RmZ7QfLsC4fDzLVj9WrocuDAz+dAQB8OJ6Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2012 12:22 AM, Dave Young wrote:
> On Thu, Nov 29, 2012 at 5:47 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>
> Hi, Yinghai and HPA
>
> What's the staus of this patch,  will it go for 3.8? Is there anything
> blocking this patch?
>

It's 3.9 material at this point.  The sheer size and messiness of the 
whole set has been the holdup.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

