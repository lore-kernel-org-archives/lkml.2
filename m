Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933734Ab1ERT1m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 15:27:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62845 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933632Ab1ERT1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 15:27:38 -0400
Date: Wed, 18 May 2011 20:45:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
Subject: Re: [PATCH 01/10] signal: remove three noop tracehooks
Message-ID: <20110518184559.GB1064@redhat.com>
References: <1305569849-10448-1-git-send-email-tj@kernel.org> <1305569849-10448-2-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305569849-10448-2-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16, Tejun Heo wrote:
>
> these hooks don't do anything
> other than obfuscating the logic.

Heh. What can I say? Yes, this is true. Of course this breaks the out-of-tree
project, completely, and you even know its name ;) Although tracehook_get_signal()
logic was already broken by other changes...

Reviewed-by: Oleg Nesterov <oleg@redhat.com>

