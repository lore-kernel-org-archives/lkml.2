Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332Ab1HXJVb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 05:21:31 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:61948 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab1HXJV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 05:21:28 -0400
MIME-Version: 1.0
In-Reply-To: <20110824085329.GL29452@sun>
References: <20110824085329.GL29452@sun>
Date: Wed, 24 Aug 2011 12:21:27 +0300
X-Google-Sender-Auth: naKNdA9oswdDZzI0e1LUi7XB5JQ
Message-ID: <CAOJsxLGVLAV7JF=kJmHU7gzyTe3W94Fx5d6qjikrS=2Yw2=Muw@mail.gmail.com>
Subject: Re: [RFC] fs, proc: Introduce the /proc/<pid>/map_files/ directory v2
From: Pekka Enberg <penberg@kernel.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Nathan Lynch <ntl@pobox.com>, Oren Laadan <orenl@cs.columbia.edu>,
        Daniel Lezcano <dlezcano@fr.ibm.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>, containers@lists.osdl.org,
        linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        LINUXFS-ML <linux-fsdevel@vger.kernel.org>,
        James Bottomley <jbottomley@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 11:53 AM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> From: Pavel Emelyanov <xemul@parallels.com>
>
> This one behaves similarly to the /proc/<pid>/fd/ one - it contains symlinks
> one for each mapping with file, the name of a symlink is vma->vm_start, the
> target is the file. Opening a symlink results in a file that point exactly
> to the same inode as them vma's one.
>
> This thing is aimed to help checkpointing processes.

OK, but you really should explain _how_ this will help with checkpointing.

                        Pekka
