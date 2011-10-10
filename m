Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab1JJKSX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 06:18:23 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49838 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097Ab1JJKSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 06:18:22 -0400
MIME-Version: 1.0
In-Reply-To: <fced9ea9f590d664a08a1f5425adfc5afa1d5949.1318233879.git.joe@perches.com>
References: <CAKYAXd9csZyMXAy_uopb-fHKtY8VBjWD6UVdbQ3QTHYPogLVrw@mail.gmail.com>
	<cover.1318233879.git.joe@perches.com>
	<fced9ea9f590d664a08a1f5425adfc5afa1d5949.1318233879.git.joe@perches.com>
Date: Mon, 10 Oct 2011 19:18:21 +0900
Message-ID: <CAKYAXd8XCR14M9goZrF4N0iKhMnwOOa+9OT1_StNYWGT6e2X5A@mail.gmail.com>
Subject: Re: [PATCH 2/6] udf: Rename udf_error to udf_err
From: NamJae Jeon <linkinjeon@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/10 Joe Perches <joe@perches.com>:
> Rename udf_error to udf_err for consistency with normal logging
> uses of pr_err.
>
> Rename function udf_err to _udf_err.
> Remove __func__ from uses and move __func__ to a new udf_err
> macro that calls _udf_err.
> Some of the udf_error uses had \n terminations, some did not so
> standardize \n's to udf_err uses, remove \n from _udf_err function.
> Coalesce udf_err formats.
> One message prefixed with udf_read_super is now prefixed with
> udf_fill_super.
>
> Signed-off-by: Joe Perches <joe@perches.com>
Reviewed-by: NamJae Jeon <linkinjeon@gmail.com>
