Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735Ab2GMPon (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 11:44:43 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:38940 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab2GMPom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 11:44:42 -0400
MIME-Version: 1.0
In-Reply-To: <20120713153827.GA8007@hp.com>
References: <20120713153827.GA8007@hp.com>
Date: Fri, 13 Jul 2012 10:44:41 -0500
X-Google-Sender-Auth: y0_ncmTVQ_H7nROl9B7ehnnCAXA
Message-ID: <CAGXu5jL61DEfbShnQSKQsaM9RzLpPp+yt2KKzii-xh0Xc0aFCw@mail.gmail.com>
Subject: Re: [PATCH] Add missing attributes to EFI variable attribute print
 out from sysfs
From: Kees Cook <keescook@chromium.org>
To: Khalid Aziz <khalid.aziz@hp.com>
Cc: linux-kernel@vger.kernel.org, tony.luck@intel.com, mikew@google.com,
        mjg@redhat.com, gong.chen@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 10:38 AM, Khalid Aziz <khalid.aziz@hp.com> wrote:
> Some of the EFI variable attributes are missing from print out from
> /sys/firmware/efi/vars/*/attributes. This patch adds those in.
>
> Signed-off-by: Khalid Aziz <khalid.aziz@hp.com>
> Cc: stable@vger.kernel.org

Seems good to me.

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
Chrome OS Security
