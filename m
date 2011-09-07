Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452Ab1IGXRs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 19:17:48 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:10780 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755582Ab1IGXRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 19:17:47 -0400
Message-ID: <4E67FB8E.5030009@cavium.com>
Date: Wed, 07 Sep 2011 16:17:34 -0700
From: David Daney <david.daney@cavium.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Someone Something <fordhaivat@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Epoll as kernel module?
References: <CAG11QsKymopV9bcUFBgDCEYdJ3Wwa0gCAov3gkXqYFXL22OxCw@mail.gmail.com>
In-Reply-To: <CAG11QsKymopV9bcUFBgDCEYdJ3Wwa0gCAov3gkXqYFXL22OxCw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Sep 2011 23:17:46.0705 (UTC) FILETIME=[5A841C10:01CC6DB4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2011 03:45 PM, Someone Something wrote:
> There are lots of old deployments that don't have epoll, and its a
> real pain writing code for these systems. Is it a good idea to write a
> module for epoll since it is basically poll running in the kernel
> space?I think it would be an excellent idea, and if there is approval
> in the community, I would be glad to start working on it, I just
> wanted your opinions before I do that.

Normally only bug fixes are applied to older kernel versions.  So as I 
see it, there are two real problems you would have:

1)  Since lack of epoll is unlikely to be viewed as a bug, I doubt any 
such patch would ever be applied to the kernels hosted on kernel.org.

2) Most of the kernels hosted on kernel.org already have working epoll, 
so no patch is needed.

But if you want to do something to the kernels you maintain, nobody 
would object.

David Daney
