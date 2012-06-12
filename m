Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234Ab2FLVPW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 17:15:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45931 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720Ab2FLVPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 17:15:21 -0400
Message-ID: <4FD7B15F.1050108@zytor.com>
Date: Tue, 12 Jun 2012 14:15:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Brandon Falk <bfalk@gamozolabs.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [question] x86/x86_64 boot process
References: <CAK9+cJX9GHjToKbOqqmink5Kr-9y3ZhQPC8M8rcL70rWbbYVYw@mail.gmail.com> <4FD7AF24.8080607@zytor.com> <CAK9+cJXLYX_20Xovy5Th7aXcznVf--RzF+GxxOWiv2gX6pETng@mail.gmail.com>
In-Reply-To: <CAK9+cJXLYX_20Xovy5Th7aXcznVf--RzF+GxxOWiv2gX6pETng@mail.gmail.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2012 02:14 PM, Brandon Falk wrote:
> All I really see related to the post-setup stage is:
> 
> 'The 32-bit (non-real-mode) kernel starts at offset (setup_sects+1)*512
> in the kernel file (again, if setup_sects == 0 the real value is 4.)
> It should be loaded at address 0x10000 for Image/zImage kernels and
> 0x100000 for bzImage kernels.'
> 
> I've read this document a few times, and it doesn't seem to mention if
> the kernel assists in loading. Do I have to load up the whole
> protected-mode kernel? Just the first few sectors? I guess that's what
> I'm trying to figure out, and I feel the boot.txt has not answered
> that for me.
> 

The kernel doesn't load anything, that is the boot loader's job.

	-hpa

