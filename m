Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000Ab2JBQXO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 12:23:14 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:53839 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754898Ab2JBQXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 12:23:12 -0400
MIME-Version: 1.0
In-Reply-To: <15670.1349125526@warthog.procyon.org.uk>
References: <15670.1349125526@warthog.procyon.org.uk>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Tue, 2 Oct 2012 17:22:51 +0100
X-Google-Sender-Auth: tvGmdW9fer2gujSmDqvSYYYZ6PA
Message-ID: <CAHkRjk4Nv-Wb6NA9tZkLPQw8NFvTXMScF3x6i=e+KeBC0uF6Dw@mail.gmail.com>
Subject: Re: [GIT PULL] Disintegrate the User API from the kernel headers
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, arnd@arndb.de, hpa@zytor.com, alan@lxorguk.ukuu.org.uk,
        fengguang.wu@intel.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On 1 October 2012 22:05, David Howells <dhowells@redhat.com> wrote:
> Could you please pull this tree at the _end_ of this merge window?
>
> The patches therein extract the Userspace API bits from the various header
> files named in the Kbuild files and separate them out into their own files.
> The original files are then given #includes to the new files.
>
> Each new file appears in a subdirectory under either include/uapi/ or
> arch/x/include/uapi/ that corresponds to the subdirectory containing that file
> under include/ or arch/x/include/.
...
> NOTE!  These patches may need regenerating if the header files change too much
> during the remainder of the merge window.  This can mostly be handled
> automatically as the disintegration procedure is scripted.

There is arm64 that got merged, so its headers need splitting as well.
I'm happy to send a pull request myself just for arm64 if you give me
the script, otherwise you can run you script again close to -rc1 (and
I'll test it).

Thanks.

-- 
Catalin
