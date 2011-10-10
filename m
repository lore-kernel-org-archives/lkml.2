Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab1JJKV6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 06:21:58 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58628 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097Ab1JJKV5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 06:21:57 -0400
MIME-Version: 1.0
In-Reply-To: <2eb3e996c9fd511f4c3dbf6f26efa3481b70a87a.1318233879.git.joe@perches.com>
References: <CAKYAXd9csZyMXAy_uopb-fHKtY8VBjWD6UVdbQ3QTHYPogLVrw@mail.gmail.com>
	<cover.1318233879.git.joe@perches.com>
	<2eb3e996c9fd511f4c3dbf6f26efa3481b70a87a.1318233879.git.joe@perches.com>
Date: Mon, 10 Oct 2011 19:21:56 +0900
Message-ID: <CAKYAXd-7TB7=EEth-B4vHE+qLGx5+uHC9SXQGPCZwsyru4Vqaw@mail.gmail.com>
Subject: Re: [PATCH 4/6] udf: Convert printks to pr_<level>
From: NamJae Jeon <linkinjeon@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/10 Joe Perches <joe@perches.com>:
> Use the current logging styles.
>
> Convert a few printks that should have been udf_warn and udf_err.
> Coalesce formats.  Add #define pr_fmt.
> Move an #include "udfdecls.h" above other includes in udftime.c
> so pr_fmt works correctly.  Strip prefixes from conversions as appropriate.
> Reorder logging definitions in udfdecl.h
>
> Signed-off-by: Joe Perches <joe@perches.com>
Reviewed-by: NamJae Jeon <linkinjeon@gmail.com>
> ---
