Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156Ab2DFVCj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 17:02:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46290 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758057Ab2DFVCf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 17:02:35 -0400
Message-ID: <4F7F59E1.2040009@zytor.com>
Date: Fri, 06 Apr 2012 14:02:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org, drepper@gmail.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] nextfd(2)
References: <20120401125741.GA7484@p183.telecom.by> <4F78D0BA.9040709@zytor.com> <CACVxJT_WJYjecpZMGkyUrbE5gNROX1tOfFAcD84-hoPsypxcFQ@mail.gmail.com> <4F7F1659.5090305@zytor.com> <20120406201601.GA3310@p183.telecom.by>
In-Reply-To: <20120406201601.GA3310@p183.telecom.by>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2012 01:16 PM, Alexey Dobriyan wrote:
> 
> closefrom(3) written via nextfd(2) loop is reliable and doesn't fail.
> closefrom(3) written via /proc/self/fd is reliable and can fail (including ENOMEM).
> closefrom(3) written via close(fd++) is unreliable.
> 

I call shenanigans on this.  There is no reason to ENOMEM on the second
written using the fdwalk() implementation I already posted, for example.

	-hpa


