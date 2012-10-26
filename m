Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933550Ab2JZO4O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 10:56:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34775 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675Ab2JZO4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 10:56:13 -0400
MIME-Version: 1.0
In-Reply-To: <1351263079-28391-1-git-send-email-ming.lei@canonical.com>
References: <1351263079-28391-1-git-send-email-ming.lei@canonical.com>
Date: Fri, 26 Oct 2012 22:56:11 +0800
Message-ID: <CACVXFVNgF8TPmpL4M8MetH8-Mx5m5acfEBc8px3W4-t=e7-hyA@mail.gmail.com>
Subject: Re: [PATCH v2] firmware loader: introduce module parameter to
 customize fw search path
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 10:51 PM, Ming Lei <ming.lei@canonical.com> wrote:
> +
> +               /* skip the unset customized path */
> +               if (!fw_path[0])

There is one mistake above and should be below, sorry for the noise.

                     if (!fw_path[i][0])


Thanks,
--
Ming Lei
