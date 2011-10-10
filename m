Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375Ab1JJKSx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 06:18:53 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49838 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097Ab1JJKSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 06:18:52 -0400
MIME-Version: 1.0
In-Reply-To: <6444365c4b22de07d3690de95a7912badfb73e80.1318233879.git.joe@perches.com>
References: <CAKYAXd9csZyMXAy_uopb-fHKtY8VBjWD6UVdbQ3QTHYPogLVrw@mail.gmail.com>
	<cover.1318233879.git.joe@perches.com>
	<6444365c4b22de07d3690de95a7912badfb73e80.1318233879.git.joe@perches.com>
Date: Mon, 10 Oct 2011 19:18:51 +0900
Message-ID: <CAKYAXd9q+jq=WRq9YOBApw7PbNKrMwE-Nq8V4NeSyJFtdmchQQ@mail.gmail.com>
Subject: Re: [PATCH 3/6] udf: Rename udf_warn to udf_warn
From: NamJae Jeon <linkinjeon@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/10 Joe Perches <joe@perches.com>:
> Rename udf_warning to udf_warn for consistency with normal logging
> uses of pr_warn.
>
> Rename function udf_warning to _udf_warn.
> Remove __func__ from uses and move __func__ to a new udf_warn
> macro that calls _udf_warn.
> Add \n's to uses of udf_warn, remove \n from _udf_warn.
> Coalesce formats.
>
> Signed-off-by: Joe Perches <joe@perches.com>
Reviewed-by: NamJae Jeon <linkinjeon@gmail.com>
> ---
