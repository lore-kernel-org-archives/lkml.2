Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308Ab1GKLuq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 07:50:46 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47576 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228Ab1GKLuo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 07:50:44 -0400
MIME-Version: 1.0
In-Reply-To: <4E19ED0A.9000709@zytor.com>
References: <1310306000-2447-1-git-send-email-brgerst@gmail.com>
	<4E19ED0A.9000709@zytor.com>
Date: Mon, 11 Jul 2011 07:50:43 -0400
Message-ID: <CAMzpN2gK2UTdZzGMr1GYD-qQ0r9cKdGUx7kHG2Z5p5iRJdY7dA@mail.gmail.com>
Subject: Re: [PATCH 1/2] x86-64: Simplify cpu_has_invlpg
From: Brian Gerst <brgerst@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 10, 2011 at 2:18 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 07/10/2011 06:53 AM, Brian Gerst wrote:
>> Define CONFIG_X86_INVLPG for 64-bit too, which simplifies the code.
>>
>> Signed-off-by: Brian Gerst <brgerst@gmail.com>
>
> I think a much better way to do this kind of stuff is to define
> Linux-specific CPU feature bits (which we already have quite a few of).
>  That way they fall into the same mechanism as everything else that has
> switches on CPU features, we can use alternatives, and so on.

I don't think it's worth getting too fancy with this.  Even if you
used alternatives, you'd want the config option to eliminate the
alternative when compiling for 486+.

--
Brian Gerst
