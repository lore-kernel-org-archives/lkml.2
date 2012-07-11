Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030217Ab2GKUnG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 16:43:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52202 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030188Ab2GKUnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 16:43:02 -0400
Date: Wed, 11 Jul 2012 13:42:59 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Arnd Bergmann <arnd@arndb.de>
cc: Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>,
        linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm/slob: avoid type warning about alignment value
In-Reply-To: <201207110639.43587.arnd@arndb.de>
Message-ID: <alpine.DEB.2.00.1207111342180.3635@chino.kir.corp.google.com>
References: <201207102055.35278.arnd@arndb.de> <alpine.DEB.2.00.1207101815580.684@chino.kir.corp.google.com> <201207110639.43587.arnd@arndb.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2012, Arnd Bergmann wrote:

> Also, size_t seems to be the correct type here, while the untyped
> definition is just an int.
> 

Ok, sounds good, thanks.

Acked-by: David Rientjes <rientjes@google.com>
