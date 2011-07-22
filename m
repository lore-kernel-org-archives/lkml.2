Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab1GVPfF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 11:35:05 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:33168 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524Ab1GVPfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 11:35:03 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1107220933570.2707@router.home>
References: <20110721184436.GA7474@debian> <alpine.DEB.2.00.1107211351250.3995@router.home>
 <alpine.DEB.2.00.1107220933570.2707@router.home>
From: Rabin Vincent <rabin@rab.in>
Date: Fri, 22 Jul 2011 21:04:21 +0530
X-Google-Sender-Auth: QsgLxeHlxyzqbuXsxdmDM5AtGiQ
Message-ID: <CAH+eYFD6OicmkwJMd04u4WXRWt4gxwavQ6duhYBNC0h04pUfog@mail.gmail.com>
Subject: Re: "slub: Rework allocator fastpaths" and slub debugging
To: Christoph Lameter <cl@linux.com>
Cc: penberg@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 22, 2011 at 20:05, Christoph Lameter <cl@linux.com> wrote:
> Subject: slub: When allocating a new slab also prep the first object
>
> We need to branch to the debug code for the first object if we allocate
> a new slab otherwise the first object will be marked wrongly as inactive.
>
> Signed-off-by: Christoph Lameter <cl@linux.com>

Tested-by: Rabin Vincent <rabin@rab.in>

Thanks.
