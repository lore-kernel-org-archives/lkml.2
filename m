Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776Ab1LWLjX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 06:39:23 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40836 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322Ab1LWLjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 06:39:19 -0500
MIME-Version: 1.0
In-Reply-To: <1324638633-25230-1-git-send-email-jack@suse.cz>
References: <1324638633-25230-1-git-send-email-jack@suse.cz>
Date: Fri, 23 Dec 2011 20:39:17 +0900
Message-ID: <CAKYAXd83vzH7j0H1HyvFz=ue8bGxFD5vPfyyN=Spj46dqmO5Tw@mail.gmail.com>
Subject: Re: [PATCH] udf: Mark LVID buffer as uptodate before marking it dirty
From: Namjae Jeon <linkinjeon@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/12/23 Jan Kara <jack@suse.cz>:
> When we hit EIO while writing LVID, the buffer uptodate bit is cleared.
> This then results in an anoying warning from mark_buffer_dirty() when we
> write the buffer again. So just set uptodate flag unconditionally.
>
> Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Namjae Jeon <linkinjeon@gmail.com>
> ---
Hi. Jan.
looks good to me !!.
Thanks.
