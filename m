Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504Ab1HUOqY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 10:46:24 -0400
Received: from lo.gmane.org ([80.91.229.12]:49337 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754867Ab1HUOqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 10:46:23 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Wanlong Gao <wanlong.gao@gmail.com>
Subject: Re: [Doc] =?utf-8?b?Y2xhc3NfZmluZF9kZXZpY2U6?= fix reference to argument 
Date: Sun, 21 Aug 2011 14:46:04 +0000 (UTC)
Message-ID: <loom.20110821T164259-39@post.gmane.org>
References: <201108211256.43836.eike@sf-mail.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 112.80.209.86 (Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/535.1 (KHTML, like Gecko) Chrome/14.0.835.94 Safari/535.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rolf Eike Beer <eike <at> sf-mail.de> writes:

> 
> Signed-off-by: Rolf Eike Beer <eike-kernel <at> sf-tec.de>
> ---
>  drivers/base/class.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 

> - * @fn is allowed to do anything including calling back into class
> + * @match is allowed to do anything including calling back into class
>   * code.  There's no locking restriction.
>   */
>  struct device *class_find_device(struct class *class, struct device *start,

NACK, it means the function class_find_device but not the @match.

Thanks
-Wanlong Gao


