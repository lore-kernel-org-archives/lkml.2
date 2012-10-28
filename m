Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102Ab2J1MH2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 08:07:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39527 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab2J1MH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 08:07:27 -0400
MIME-Version: 1.0
In-Reply-To: <1351377430-21247-1-git-send-email-cesarb@cesarb.net>
References: <1351377430-21247-1-git-send-email-cesarb@cesarb.net>
Date: Sun, 28 Oct 2012 20:07:24 +0800
Message-ID: <CACVXFVM+4_ZtPAmF6=i5zX+2XwK4kE6DfvRJ0x+e8e-nobwtmw@mail.gmail.com>
Subject: Re: [PATCH] firmware: use noinline_for_stack
From: Ming Lei <ming.lei@canonical.com>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 28, 2012 at 6:37 AM, Cesar Eduardo Barros <cesarb@cesarb.net> wrote:
> The comment above fw_file_size() suggests it is noinline for stack size
> reasons. Use noinline_for_stack to make this more clear.

Acked-by: Ming Lei <ming.lei@canonical.com>



Thanks,
--
Ming Lei
