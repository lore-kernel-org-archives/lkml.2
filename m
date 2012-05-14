Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757124Ab2ENQvc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 12:51:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57954 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753381Ab2ENQvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 12:51:31 -0400
Message-ID: <4FB1380B.3020802@zytor.com>
Date: Mon, 14 May 2012 09:51:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: linux-kernel@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
        Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH] x86/vga: set the default device from the fixup.
References: <1337011280-7166-1-git-send-email-airlied@gmail.com>
In-Reply-To: <1337011280-7166-1-git-send-email-airlied@gmail.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2012 09:01 AM, Dave Airlie wrote:
> From: Dave Airlie <airlied@redhat.com>
> 
> Since Matthew's efi/vga changes on non-EFI machines we were failing
> to tell the vgaarb/switcheroo what the default device was, this
> sets the default device in the quirk if none has been set before.
> 
> This fixes the switcheroo on my T410s.
> 
> [hpa: please ack to put this on top of the other patches in my -next tree].
> 
> Signed-off-by: Dave Airlie <airlied@redhat.com>
> Cc: Matthew Garrett <mjg@redhat.com>
> Cc: H. Peter Anvin <hpa@zytor.com>

Acked-by: H. Peter Anvin <hpa@zytor.com>

... although I would prefer the

	if (!vga_default_device())

syntax as a matter of style.

	-hpa
