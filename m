Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674Ab2KFT07 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 14:26:59 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34568 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556Ab2KFT06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 14:26:58 -0500
Date: Tue, 6 Nov 2012 11:26:55 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] irq: tsk->comm is an array
In-Reply-To: <20121106142849.21834.20965.stgit@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.1211061126420.4817@chino.kir.corp.google.com>
References: <20121106142849.21834.20965.stgit@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Nov 2012, Alan Cox wrote:

> From: Alan Cox <alan@linux.intel.com>
> 
> The array check is useless so remove it.
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>

Acked-by: David Rientjes <rientjes@google.com>
