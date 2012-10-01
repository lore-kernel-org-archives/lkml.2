Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158Ab2JAM5O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 08:57:14 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:55197 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab2JAM5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 08:57:13 -0400
MIME-Version: 1.0
In-Reply-To: <4347_1349050738_q910IviQ005340_20120930233012.GH30637@obsidianresearch.com>
References: <4347_1349050738_q910IviQ005340_20120930233012.GH30637@obsidianresearch.com>
Date: Mon, 1 Oct 2012 08:57:11 -0400
Message-ID: <CAEwYmTLuxx8UKvkF7cE4LF++K77mDkiB3e6MD6Eao9KYJreO8w@mail.gmail.com>
Subject: Re: [tpmdd-devel] [PATCH] TPM: Issue TPM_STARTUP at driver load if
 the TPM has not been started
From: Jonathan McCune <jonmccune@gmail.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

On Sun, Sep 30, 2012 at 7:30 PM, Jason Gunthorpe
<jgunthorpe@obsidianresearch.com> wrote:
> The TPM will respond to TPM_GET_CAP with TPM_ERR_INVALID_POSTINIT if
> TPM_STARTUP has not been issued. This will result in the TPM driver
> failing to load and no way to recover. Detect this and automatically
> issue TPM_STARTUP.
>
> This is for embedded applications where the kernel is the first thing
> to touch the TPM.

I welcome such functionality.  Thanks for your efforts.

Regards,
-Jon
