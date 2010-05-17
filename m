Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab0EQSOO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 14:14:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46203 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754507Ab0EQSON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 14:14:13 -0400
Message-ID: <4BF18760.2090907@zytor.com>
Date: Mon, 17 May 2010 11:13:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       Srinivas Nayak <sinu.nayak2001@gmail.com>,
       Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Which function returns LWP in Linux.
References: <AANLkTikD7M_PKH3YgOWIvrcD6aW6X-gYIo2iw52QRRq_@mail.gmail.com> <20100517160319.A195.A69D9226@jp.fujitsu.com> <AANLkTik2OcSBGdkRQKFl6xh06PEr7Al6xaUsmMGGC6jo@mail.gmail.com> <AANLkTilGLJJG_eLHaqvJ5jOzxp96SbOroTCbHe9g5TXE@mail.gmail.com> <20100517133012.GC26359@const.bordeaux.inria.fr>
In-Reply-To: <20100517133012.GC26359@const.bordeaux.inria.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2010 06:30 AM, Samuel Thibault wrote:
> Srinivas Nayak, le Mon 17 May 2010 15:43:17 +0530, a écrit :
>> After some more research, i foind that
>>
>> syscall(SYS_gettid)
>>
>> returns LWP id. Isn't this correct?
> 
> It is correct only on Linux, but yes.
> 

For libc's notion of the current thread, pthread_self(3).

	-hpa
