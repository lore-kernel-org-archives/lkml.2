Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965151Ab1GMJUv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 05:20:51 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:33664 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965108Ab1GMJUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 05:20:50 -0400
MIME-Version: 1.0
In-Reply-To: <1310393989.3058.5.camel@castor.rsk>
References: <1310393989.3058.5.camel@castor.rsk>
Date: Wed, 13 Jul 2011 11:20:49 +0200
X-Google-Sender-Auth: DaCM4P89v7Gi27cCp-_VxnHCjx8
Message-ID: <CAOS58YOXtoVwNc2NOWvrzhBMb0gTRyRCz3KBXFoC2s9-U3mFXA@mail.gmail.com>
Subject: Re: [PATCH] block: reorder request_queue to remove 64 bit alignment padding
From: Tejun Heo <tj@kernel.org>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Jens Axboe <jaxboe@fusionio.com>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Jul 11, 2011 at 4:19 PM, Richard Kennedy
<richard@rsk.demon.co.uk> wrote:
> Reorder request_queue to remove 16 bytes of alignment padding in 64 bit
> builds.
>
> On my config this shrinks the size of this structure from 1608 to 1592
> bytes and therefore needs one fewer cachelines.
>
> Also trivially move the open bracket { to be on the same line as the
> structure name to make it easier to grep.
>
>
> Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>

Acked-by: Tejun Heo <tj@kernel.org>

Thank you.

-- 
tejun
