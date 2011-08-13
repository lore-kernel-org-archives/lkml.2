Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751218Ab1HMG6Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 02:58:24 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:41383 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab1HMG6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 02:58:23 -0400
Subject: Re: [PATCH 1/2] slub: extend slub_debug to handle multiple slabs
From: Pekka Enberg <penberg@kernel.org>
To: Iliyan Malchev <malchev@google.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>
In-Reply-To: <1312839019-17987-1-git-send-email-malchev@google.com>
References: <1312839019-17987-1-git-send-email-malchev@google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Sat, 13 Aug 2011 09:58:21 +0300
Message-ID: <1313218701.29737.38.camel@jaguar>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-08 at 14:30 -0700, Iliyan Malchev wrote:
> Extend the slub_debug syntax to "slub_debug=<flags>[,<slub>]*", where <slub>
> may contain an asterisk at the end.  For example, the following would poison
> all kmalloc slabs:
> 
> 	slub_debug=P,kmalloc*
> 
> and the following would apply the default flags to all kmalloc and all block IO
> slabs:
> 
> 	slub_debug=,bio*,kmalloc*
> 
> Signed-off-by: Iliyan Malchev <malchev@google.com>

Christoph, David, are you OK with the patches? They look reasonable to
me.

