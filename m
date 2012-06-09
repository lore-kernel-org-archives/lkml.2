Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab2FIJOc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 05:14:32 -0400
Received: from linux-sh.org ([111.68.239.195]:45238 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798Ab2FIJOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 05:14:30 -0400
Date: Sat, 9 Jun 2012 18:14:26 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        <linux-sh@vger.kernel.org>
Subject: Re: [PATCH 1/6] sh: fix compiler warning by properly inlining
 flat_set_persistent()
Message-ID: <20120609091426.GA10170@linux-sh.org>
References: <1339229611-2326-1-git-send-email-elezegarcia@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339229611-2326-1-git-send-email-elezegarcia@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 09, 2012 at 05:13:26AM -0300, Ezequiel Garcia wrote:
> This patch removes the following warning:
> fs/binfmt_flat.c:752: warning: unused variable ???persistent???
> There is neither change in functionality, nor extra code generated.
> 
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: <linux-sh@vger.kernel.org>
> Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>

That's what the cast was for, with what gcc version did that stop
working?
