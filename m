Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab2FLT7N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 15:59:13 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39580 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934Ab2FLT7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 15:59:11 -0400
MIME-Version: 1.0
In-Reply-To: <1339531019-17040-1-git-send-email-bfreed@chromium.org>
References: <1339531019-17040-1-git-send-email-bfreed@chromium.org>
Date: Tue, 12 Jun 2012 12:59:10 -0700
X-Google-Sender-Auth: c3klPcArdZ7Tns-2asABZiDUXf8
Message-ID: <CAGXu5j+nJwW1hZ2Wgqd5kx5YNvEjS+2oSZyV3Rnm7M4Yaa=jhg@mail.gmail.com>
Subject: Re: [PATCH v4] pstore/ram: Add ramoops support for the Flattened
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

On Tue, Jun 12, 2012 at 12:56 PM, Bryan Freed <bfreed@chromium.org> wrote:
> When called with a non-zero of_node, fill out a new ramoops_platform_data
> with data from the specified Flattened Device Tree node.
> Update ramoops documentation with the new FDT interface.
> Update devicetree/binding documentation with pstore/ramoops.txt.
>
> Signed-off-by: Bryan Freed <bfreed@chromium.org>

Acked-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
Chrome OS Security
