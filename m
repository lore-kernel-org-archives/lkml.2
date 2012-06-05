Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946Ab2FEVKl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 17:10:41 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63399 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854Ab2FEVKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 17:10:39 -0400
MIME-Version: 1.0
In-Reply-To: <1338927793-5096-1-git-send-email-bfreed@chromium.org>
References: <1338927793-5096-1-git-send-email-bfreed@chromium.org>
Date: Tue, 5 Jun 2012 14:10:37 -0700
X-Google-Sender-Auth: jItowOH0bXPUC-bLWjreISaqcpw
Message-ID: <CAGXu5jK9xaCt9dR3qC-t79HYyk0E3tFxBdbAzS9Rb4LdhbcYnQ@mail.gmail.com>
Subject: Re: [PATCH v2] pstore/ram: Add ramoops support for the Flattened
 Device Tree.
From: Kees Cook <keescook@chromium.org>
To: Bryan Freed <bfreed@chromium.org>
Cc: linux-kernel@vger.kernel.org, marco.stornelli@gmail.com,
        grant.likely@secretlab.ca, anton.vorontsov@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 5, 2012 at 1:23 PM, Bryan Freed <bfreed@chromium.org> wrote:
> When called with a non-zero of_node, fill out a new ramoops_platform_data
> with data from the specified Flattened Device Tree node.
> Update ramoops documentation with the new FDT interface.
>
> Signed-off-by: Bryan Freed <bfreed@chromium.org>

Acked-by: Kees Cook <keescook@chromium.org>

Looks good, thanks!

-Kees

-- 
Kees Cook
Chrome OS Security
