Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757058Ab2DIRpq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 13:45:46 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:61626 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754932Ab2DIRpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 13:45:45 -0400
MIME-Version: 1.0
In-Reply-To: <1333993497-28215-1-git-send-email-sboyd@codeaurora.org>
References: <1333993497-28215-1-git-send-email-sboyd@codeaurora.org>
Date: Mon, 9 Apr 2012 10:45:43 -0700
X-Google-Sender-Auth: 3u-FujYJRQY22M1b0toWSCzHOQM
Message-ID: <CAOS58YPdiFx9S+=b8NKcBTqEyykha_bpo8kgKX6D2HoLTRNXkw@mail.gmail.com>
Subject: Re: [TRIVIAL/PATCH] workqueue: Fix workqueue_execute_end() comment
From: Tejun Heo <tj@kernel.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 9, 2012 at 10:44 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>
> workqueue_execute_end() is called after the callback function,
> not before.
>
> Cc: Tejun Heo <tj@kernel.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

--
tejun
