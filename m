Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401Ab1BXAnn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 19:43:43 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63951 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457Ab1BXAnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 19:43:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=WmoovOy/ZHdfZcwpAL5zAgYkU6fp9R9ugKG+CZgLJJaqxNPjhvKta23H5yu/ucf8mY
         gfcLSifJv9J6qczzoTChWAZv2vK++8rF8DQkusG1YZdZK9Yzobotdj7pP9EBwRqqO+2v
         YYm2d3wSO78sRGbzJ5MWcQ0NhcBi1kwQbxP3s=
MIME-Version: 1.0
In-Reply-To: <AANLkTinD2cC9dGg2eBtZQhWvhSsuH2BcWDj8byLhWWso@mail.gmail.com>
References: <AANLkTi=TTZ57d1wUz1uH3R6igN8O77iDvSLMW=t86g9V@mail.gmail.com>
	<20110222140349.GA20708@kryptos.osrc.amd.com>
	<AANLkTikESHHfjBqoLFOno6qQz-NXEAo-wBY5JEeAW61N@mail.gmail.com>
	<AANLkTinh4pF7iaUGMcv_9gPy+VBD5POsTHbF_2zPJ17r@mail.gmail.com>
	<AANLkTi=Ys4mb4pc28cH4NMdtMgb2KewJbkXEGJmEP4J0@mail.gmail.com>
	<AANLkTinxHVDwSCouTaZEvR3yTJnSPAas9z6JauGDdS7=@mail.gmail.com>
	<AANLkTinD2cC9dGg2eBtZQhWvhSsuH2BcWDj8byLhWWso@mail.gmail.com>
Date: Thu, 24 Feb 2011 10:43:40 +1000
Message-ID: <AANLkTi=M0p+=mwRxZpShRU6y6iskEE5+nz6bd+9kek3Y@mail.gmail.com>
Subject: Re: Linux 2.6.38-rc6
From: Dave Airlie <airlied@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Anca Emanuel <anca.emanuel@gmail.com>, Dave Airlie <airlied@redhat.com>,
        linux-fbdev@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>,
        dri-devel@lists.freedesktop.org, Borislav Petkov <bp@amd64.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 10:28 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Feb 23, 2011 at 9:16 AM, Anca Emanuel <anca.emanuel@gmail.com> wrote:
>>>
>>> Looks like nouveafb took over from vesafb. Did you do anything special
>>> to trigger this?
>>
>> No. Just boot the system.
>
> Every boot?
>
> And just out of interest, what happens if you don't have the vesafb
> driver at all?
>

I think this is a race condition somewhere with plymouth getting
access to vesafb before it gets kicked off the hw,

I'm assuming removing the vga= line from the command line will stop it,

Dave.
