Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278Ab1KQVfA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 16:35:00 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58611 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955Ab1KQVe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 16:34:57 -0500
Date: Thu, 17 Nov 2011 13:34:54 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Claudio Scordino <claudio@evidence.eu.com>
cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        viro@zeniv.linux.org.uk, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/base/node.c: fix compilation error
In-Reply-To: <4EC4DD20.6080201@evidence.eu.com>
Message-ID: <alpine.DEB.2.00.1111171334350.15918@chino.kir.corp.google.com>
References: <4EC4DD20.6080201@evidence.eu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Nov 2011, Claudio Scordino wrote:

> Subject: /drivers/base/node.c: fix compilation error
> From: Claudio Scordino <claudio@evidence.eu.com>
> 
> Patch to fix the error message "directives may not be used inside a macro
> argument" which appears when the kernel is compiled for the cris architecture.
> 
> Signed-off-by: Claudio Scordino <claudio@evidence.eu.com>

Acked-by: David Rientjes <rientjes@google.com>

Thanks Claudio!
