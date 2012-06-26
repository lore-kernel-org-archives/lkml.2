Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab2FZXYz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 19:24:55 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57450 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357Ab2FZXYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 19:24:54 -0400
MIME-Version: 1.0
In-Reply-To: <1340739159-26314-1-git-send-email-bfreed@chromium.org>
References: <1340739159-26314-1-git-send-email-bfreed@chromium.org>
Date: Tue, 26 Jun 2012 16:24:52 -0700
X-Google-Sender-Auth: DaXSOlijU5YPTv_lpO7aNFlD6rc
Message-ID: <CAGXu5jJWpOBqDf8mAgES_FajcyP0J5RjQTOM2O3GU4mqu_L9Xw@mail.gmail.com>
Subject: Re: [PATCH v5] pstore/ram: Add ramoops support for the Flattened
 Device Tree.
From: Kees Cook <keescook@chromium.org>
To: Bryan Freed <bfreed@chromium.org>
Cc: linux-kernel@vger.kernel.org, olof@lixom.net, marco.stornelli@gmail.com,
        grant.likely@secretlab.ca, anton.vorontsov@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 12:32 PM, Bryan Freed <bfreed@chromium.org> wrote:
> When called with a non-zero of_node, fill out a new ramoops_platform_data
> with data from the specified Flattened Device Tree node.
> Update ramoops documentation with the new FDT interface.
> Update devicetree/binding documentation with pstore/ramoops.txt.
>
> Signed-off-by: Bryan Freed <bfreed@chromium.org>

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
Chrome OS Security
