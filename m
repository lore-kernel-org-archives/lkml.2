Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936082Ab0GPJBA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 05:01:00 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:49029 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936027Ab0GPJA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 05:00:58 -0400
Message-ID: <4C401FC1.3030300@cs.helsinki.fi>
Date: Fri, 16 Jul 2010 12:00:49 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: linux-kernel@vger.kernel.org, Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH 2/3] kmemleak: Introduce a default off mode for kmemleak
References: <20100715150703.21793.94815.stgit@e102109-lin.cambridge.arm.com> <20100715150907.21793.63966.stgit@e102109-lin.cambridge.arm.com>
In-Reply-To: <20100715150907.21793.63966.stgit@e102109-lin.cambridge.arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Catalin Marinas wrote:
> From: Jason Baron <jbaron@redhat.com>
> 
> Introduce a new DEBUG_KMEMLEAK_DEFAULT_OFF config parameter that allows
> kmemleak to be disabled by default, but enabled on the command line
> via: kmemleak=on. Although a reboot is required to turn it on, its still
> useful to not require a re-compile.
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Pekka Enberg <penberg@cs.helsinki.fi>

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
