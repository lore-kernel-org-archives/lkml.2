Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964800Ab1GJSTH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 14:19:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55369 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756299Ab1GJSTD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 14:19:03 -0400
Message-ID: <4E19ED0A.9000709@zytor.com>
Date: Sun, 10 Jul 2011 11:18:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86-64: Simplify cpu_has_invlpg
References: <1310306000-2447-1-git-send-email-brgerst@gmail.com>
In-Reply-To: <1310306000-2447-1-git-send-email-brgerst@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2011 06:53 AM, Brian Gerst wrote:
> Define CONFIG_X86_INVLPG for 64-bit too, which simplifies the code.
> 
> Signed-off-by: Brian Gerst <brgerst@gmail.com>

I think a much better way to do this kind of stuff is to define
Linux-specific CPU feature bits (which we already have quite a few of).
 That way they fall into the same mechanism as everything else that has
switches on CPU features, we can use alternatives, and so on.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

