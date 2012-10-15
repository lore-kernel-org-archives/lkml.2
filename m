Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238Ab2JOPal (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 11:30:41 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:33574 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964Ab2JOPak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 11:30:40 -0400
Date: Mon, 15 Oct 2012 19:30:34 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, criu@openvz.org, ebiederm@xmission.com,
        rientjes@google.com, devel@openvz.org
Subject: Re: [PATCH] proc: check vma->vm_file before dereferencing
Message-ID: <20121015153034.GM18119@moon>
References: <20121015152957.24859.7960.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121015152957.24859.7960.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 07:30:03PM +0400, Stanislav Kinsbursky wrote:
> It can be equal to NULL.
> 
> Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>

Thanks, Stas!
