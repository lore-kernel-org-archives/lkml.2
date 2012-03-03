Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758689Ab2CCAjC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 19:39:02 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48199 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758427Ab2CCAjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 19:39:00 -0500
Message-ID: <4F516811.8060800@zytor.com>
Date: Fri, 02 Mar 2012 16:38:41 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: Word-at-a-time dcache name accesses (was Re: .. anybody know
 of any filesystems that depend on the exact VFS 'namehash' implementation?)
References: <alpine.LFD.2.02.1203021544300.28247@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.02.1203021544300.28247@i5.linux-foundation.org>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2012 03:46 PM, Linus Torvalds wrote:
> 
> Comments?
> 

My biggest concern is what happens when this happens to be at the end of
mapped kernel memory and we overrun the page?

	-hpa

