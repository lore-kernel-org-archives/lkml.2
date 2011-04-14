Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932381Ab1DNIi7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 04:38:59 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46466 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758487Ab1DNIif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 04:38:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=szeredi.hu; s=google;
        h=mime-version:x-originating-ip:in-reply-to:references:date
         :message-id:subject:from:to:cc:content-type;
        b=jXLRZoNGG6cZ3a3eWg1u+0WJBepSdTzT/E/LlTR/p0sOK6/SPYNYAL0WMSYky7CiRX
         iPPrO1+d0V2iW2k8OPDqk9Cl1RQP4sAPgnqc+1JFivwMv20PBNNHDvwZoVIODSs3cCZL
         //X/jmDdG22XLzwLcTKtXy7icNBP5WvgTcMR4=
MIME-Version: 1.0
X-Originating-IP: [88.209.222.127]
In-Reply-To: <BANLkTindBULU9KAVWPJQ7oQvfCNQU-BuAg@mail.gmail.com>
References: <BANLkTini-g9XVOohKjwpZT-SGozcwx720A@mail.gmail.com>
	<4DA4B6A8.7030804@gmail.com>
	<BANLkTimsAE1ZAJhsSjnh3LqwsN9x0cLaXg@mail.gmail.com>
	<alpine.LRH.2.00.1104131618170.6953@twin.jikos.cz>
	<BANLkTindBULU9KAVWPJQ7oQvfCNQU-BuAg@mail.gmail.com>
Date: Thu, 14 Apr 2011 10:38:33 +0200
Message-ID: <BANLkTin6CVFOAECWwYg3B5V2AfscFfjt8w@mail.gmail.com>
Subject: Re: Unionmount status?
From: Miklos Szeredi <miklos@szeredi.hu>
To: Michal Suchanek <hramrach@centrum.cz>
Cc: Jiri Kosina <jkosina@suse.cz>, Ric Wheeler <ricwheeler@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>, Ian Kent <ikent@redhat.com>,
        Jeff Moyer <jmoyer@redhat.com>, Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 5:13 PM, Michal Suchanek <hramrach@centrum.cz> wrote:
> On 13 April 2011 16:18, Jiri Kosina <jkosina@suse.cz> wrote:
>> https://lkml.org/lkml/2011/3/22/222
>>
>
> Thanks for pointing out this announcement.
>
> However, neither this announcement nor the document
> Documentation/filesystems/overlayfs.txt included in the git tree
> details how to mount the filesystem. Without that it is kind of
> useless.

Oh, I'll fix that in the docs.  Thanks for pointing it out.

Here's how to mount:

  mount -t overlayfs overlayfs -olowerdir=/lower -oupperdir=/upper /overlay

Thanks,
Miklos
