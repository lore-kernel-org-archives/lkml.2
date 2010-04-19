Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab0DSM5c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 08:57:32 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:42470 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754896Ab0DSM5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 08:57:30 -0400
MIME-Version: 1.0
In-Reply-To: <20100419011617.GB22615@localhost.localdomain>
References: <20100419011617.GB22615@localhost.localdomain>
Date: Mon, 19 Apr 2010 08:57:29 -0400
Message-ID: <y2q7e0fb38c1004190557i4e421684ga5e557c6d40cb7bd@mail.gmail.com>
Subject: Re: [PATCH] Security: Fix the comment of cap_file_mmap()
From: Eric Paris <eparis@parisplace.org>
To: wzt.wzt@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       jmorris@namei.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 18, 2010 at 9:16 PM,  <wzt.wzt@gmail.com> wrote:
> In the comment of cap_file_mmap(), replace mmap_min_addr to be dac_mmap_min_addr.
>
> Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>

Thank you.

Acked-by: Eric Paris <eparis@redhat.com
