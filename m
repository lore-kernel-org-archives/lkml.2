Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357Ab1DMPOL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 11:14:11 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:59695 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757130Ab1DMPOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 11:14:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=pAcwkJZfFw63W1CfDD6WCHzJb4eCuIFzaQbtLiK+jRODt0fm+5GnhjyPZGYkuGjs37
         nLVQP3mKK2xLt7I/4M7fqw6Ud5HUcICAZ7ZrlnOresg5VzYpyFbDpGCnWLH4oNuigvNv
         Sz/XQp8cXPHbeAWirpXGe6oF4zd6xnkrfvkqI=
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.00.1104131618170.6953@twin.jikos.cz>
References: <BANLkTini-g9XVOohKjwpZT-SGozcwx720A@mail.gmail.com>
 <4DA4B6A8.7030804@gmail.com> <BANLkTimsAE1ZAJhsSjnh3LqwsN9x0cLaXg@mail.gmail.com>
 <alpine.LRH.2.00.1104131618170.6953@twin.jikos.cz>
From: Michal Suchanek <hramrach@centrum.cz>
Date: Wed, 13 Apr 2011 17:13:49 +0200
X-Google-Sender-Auth: sVCPGPR9chEBhZ2nNC_a51osgXE
Message-ID: <BANLkTindBULU9KAVWPJQ7oQvfCNQU-BuAg@mail.gmail.com>
Subject: Re: Unionmount status?
To: Jiri Kosina <jkosina@suse.cz>
Cc: Ric Wheeler <ricwheeler@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Ian Kent <ikent@redhat.com>, Jeff Moyer <jmoyer@redhat.com>,
        miklos@szeredi.hu, Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 April 2011 16:18, Jiri Kosina <jkosina@suse.cz> wrote:
> On Tue, 12 Apr 2011, Michal Suchanek wrote:
>
>> > Miklos has an overlay file system that has also been posted upstream.
>>
>> I have no idea about his other overlay filesystem either.
>
> https://lkml.org/lkml/2011/3/22/222
>

Thanks for pointing out this announcement.

However, neither this announcement nor the document
Documentation/filesystems/overlayfs.txt included in the git tree
details how to mount the filesystem. Without that it is kind of
useless.

Thanks

Michal
