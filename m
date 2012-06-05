Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932973Ab2FEKZq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 06:25:46 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:64352 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754880Ab2FEKZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 06:25:45 -0400
MIME-Version: 1.0
X-Originating-IP: [93.172.31.133]
In-Reply-To: <4FCD272E.1020300@codeaurora.org>
References: <1338017791-9442-1-git-send-email-ohad@wizery.com>
 <1338017791-9442-2-git-send-email-ohad@wizery.com> <4FC5DD74.4030202@codeaurora.org>
 <CAK=WgbbwaMAnTGcivC9ZR8K-MtTqHAV3+BgUmk8WjCaayifJxw@mail.gmail.com> <4FCD272E.1020300@codeaurora.org>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 5 Jun 2012 13:25:24 +0300
Message-ID: <CAK=WgbYbyc-xLwBeF7Sks4O=3k1QAmJLdYLL0fPdUA9hXC8bEQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] remoteproc: remove the now-redundant kref
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Fernando Guzman Lugo <fernando.lugo@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 5, 2012 at 12:22 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> Option 1 is nicer and it also follows the model other subsystems have
> put forth such as the input subsystem.

Sounds good, thanks!
