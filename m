Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535Ab1LGS0f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 13:26:35 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55899 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756504Ab1LGS0c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 13:26:32 -0500
MIME-Version: 1.0
In-Reply-To: <4EDFAECF.9010407@xenotime.net>
References: <20111206235815.GA21764@www.outflux.net>
	<4EDFAECF.9010407@xenotime.net>
Date: Wed, 7 Dec 2011 10:26:32 -0800
X-Google-Sender-Auth: cb1f1vcozP_uK2AIrwha3z4uSGw
Message-ID: <CAGXu5j+sfMLnH+j7Rhq=T-FN6ZMsznAybzAyCMDjw1kY-0PmDg@mail.gmail.com>
Subject: Re: [PATCH v2011.1] fs: symlink restrictions on sticky directories
From: Kees Cook <keescook@chromium.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Federica Teodori <federica.teodori@googlemail.com>,
        Lucian Adrian Grijincu <lucian.grijincu@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Eric Paris <eparis@redhat.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        kernel-hardening@lists.openwall.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 7, 2011 at 10:22 AM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On 12/06/2011 03:58 PM, Kees Cook wrote:
>> +       Enabling this solves the problem by permitting symlinks to only
>
> better:
>
>          Enabling this solves the problem by permitting symlinks to be followed
>          only when the uid ...
>
>> + * It will permit symlinks to only be followed when outside a sticky
>
> similar:
>
>      It will permit symlinks to be followed only when outside a sticky

Thanks! I'll update these.

-Kees

-- 
Kees Cook
ChromeOS Security
