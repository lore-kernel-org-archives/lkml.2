Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab1KVS3q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 13:29:46 -0500
Received: from natasha.panasas.com ([67.152.220.90]:35689 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859Ab1KVS3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 13:29:44 -0500
Message-ID: <4ECBEA04.5080902@panasas.com>
Date: Tue, 22 Nov 2011 10:29:24 -0800
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Josh Boyer <jwboyer@gmail.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.2-rc1
References: <CA+55aFzytqbGcOzWvYAo-EnJCeK5mFqdCF5OjMTeM5UBfeyCXw@mail.gmail.com> <4EBAB5F7.80000@xenotime.net> <CA+5PVA6tBx4i1XZ+AF=uaOsjYCshG9CzXHWjnJcsJ=z1qw1F4A@mail.gmail.com> <4ECAFDAD.5040801@panasas.com> <20111122180520.2c0c3e0f@pyx>
In-Reply-To: <20111122180520.2c0c3e0f@pyx>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2011 10:05 AM, Alan Cox wrote:
>> My god that totally-brain-dead Fedora Kernel rpm generation.
> 
> However "make rpm" from the Linus tree is meant to be as far as possible
> generic.
> 

Me bang on the head, and red of shame. I only looked at the Fedora
tree and procedure and never thought of looking in the Linux Makefile.
I think you just saved me two days of work. I'll go try that out right
now.

> Alan

Thanks a million
Boaz
