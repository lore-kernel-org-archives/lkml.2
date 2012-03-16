Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585Ab2CPTzu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 15:55:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40752 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757342Ab2CPTzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 15:55:48 -0400
Message-ID: <4F639AB0.7010208@zytor.com>
Date: Fri, 16 Mar 2012 12:55:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: wharms@bfs.de
CC: Dan Carpenter <dan.carpenter@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Matt Fleming <matt.fleming@intel.com>,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch v2] x86, efi: fix pointer math issue in handle_ramdisks()
References: <20120305180614.GA26880@elgon.mountain> <4F550917.9020508@bfs.de> <4F551504.5010401@zytor.com> <4F55CE54.4000300@bfs.de>
In-Reply-To: <4F55CE54.4000300@bfs.de>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2012 12:44 AM, walter harms wrote:
>>
> hi,
> 
> yep, but i was asking about efi. The basic idea is of cause to map efi_char16_t -> wchar_t
> and back and make this a prototype for every driver that needs a special charset.
> That would make it possible to recycle the wcs* interface of libc.
> IMHO it seems more reasonable than adding one for each (upcoming) type.
> 

Actually libc and the C standard is going the opposite ways, adding new
interfaces for UTF-16 and UTF-32.  The wchar_t interface just doesn't
work very well.

	-hpa

