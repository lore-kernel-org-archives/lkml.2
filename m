Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875Ab0GKHKq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 03:10:46 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:59317 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab0GKHKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 03:10:45 -0400
Message-ID: <4C396E6D.4030408@cs.helsinki.fi>
Date: Sun, 11 Jul 2010 10:10:37 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Cyrill Gorcunov <gorcunov@gmail.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH v2] x86: Early-boot serial I/O support
References: <1278790820-1817-1-git-send-email-penberg@cs.helsinki.fi> <20100710210750.GC6615@lenovo> <4C38E7FD.9020403@zytor.com> <20100710215554.GE6615@lenovo> <4C38F489.3090607@zytor.com>
In-Reply-To: <4C38F489.3090607@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2010 02:55 PM, Cyrill Gorcunov wrote:
>> I rather wonder -- can't we use cpu_relax() from processor.h? Or there
>> is some type conflicts?

H. Peter Anvin wrote:
> Probably.  The boot environment is pretty different, and not sharing
> header files where we don't need to because of shared data structures is
> probably a good idea.

I did try it but got bunch of compile errors and figured I was not 
supposed to use it.

			Pekka
