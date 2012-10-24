Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934789Ab2JXNgj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 09:36:39 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:1874 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752402Ab2JXNgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 09:36:38 -0400
Date: Wed, 24 Oct 2012 13:36:37 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Pekka Enberg <penberg@kernel.org>
cc: Joonsoo Kim <js1304@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH for-v3.7 1/2] slub: optimize poorly inlined kmalloc*
 functions
In-Reply-To: <CAOJsxLFay=KhhsuTho3focQ5V90k4sBCNNpyP1v29STsmDG=7Q@mail.gmail.com>
Message-ID: <0000013a92fd2f35-3d28d0e4-3419-4b78-ab29-f529b60a1c65-000000@email.amazonses.com>
References: <1350748093-7868-1-git-send-email-js1304@gmail.com> <CAOJsxLFay=KhhsuTho3focQ5V90k4sBCNNpyP1v29STsmDG=7Q@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2012, Pekka Enberg wrote:

> Looks reasonable to me. Christoph, any objections?

I am fine with it. Its going to be short lived because my latest patchset
will do the same. Can we merge this for 3.7?
