Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998Ab1DOLXE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 07:23:04 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45637 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755691Ab1DOLXB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 07:23:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=WolMlWb9KTmtQ9vlnxEfovuV+Kne7VoEmkqlIgJSfS0TjWHS4QcObggVfKBNUa6iK1
         9SrJ7pZQBDSULvLfjGg7ijoI8bwAg/rhnClbOF0XLrl+yoAArecTyC2QUNwdjEdb3OT5
         +TnARgJ7vLrAxR0VjBsyWCFdQJ5g6K4dC21JY=
MIME-Version: 1.0
In-Reply-To: <BANLkTin6CVFOAECWwYg3B5V2AfscFfjt8w@mail.gmail.com>
References: <BANLkTini-g9XVOohKjwpZT-SGozcwx720A@mail.gmail.com>
 <4DA4B6A8.7030804@gmail.com> <BANLkTimsAE1ZAJhsSjnh3LqwsN9x0cLaXg@mail.gmail.com>
 <alpine.LRH.2.00.1104131618170.6953@twin.jikos.cz> <BANLkTindBULU9KAVWPJQ7oQvfCNQU-BuAg@mail.gmail.com>
 <BANLkTin6CVFOAECWwYg3B5V2AfscFfjt8w@mail.gmail.com>
From: Michal Suchanek <hramrach@centrum.cz>
Date: Fri, 15 Apr 2011 13:22:41 +0200
X-Google-Sender-Auth: xJnsvWeWoh67LOCRNhaY4IX9RKQ
Message-ID: <BANLkTik7jasnvqFQohRdU-3crM8fr9pBXg@mail.gmail.com>
Subject: Re: Unionmount status?
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jiri Kosina <jkosina@suse.cz>, Ric Wheeler <ricwheeler@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>, Ian Kent <ikent@redhat.com>,
        Jeff Moyer <jmoyer@redhat.com>, Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 April 2011 10:38, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Wed, Apr 13, 2011 at 5:13 PM, Michal Suchanek <hramrach@centrum.cz> wrote:
>> On 13 April 2011 16:18, Jiri Kosina <jkosina@suse.cz> wrote:
>>> https://lkml.org/lkml/2011/3/22/222
>>>
>>
>> Thanks for pointing out this announcement.
>>
>> However, neither this announcement nor the document
>> Documentation/filesystems/overlayfs.txt included in the git tree
>> details how to mount the filesystem. Without that it is kind of
>> useless.
>
> Oh, I'll fix that in the docs.  Thanks for pointing it out.
>
> Here's how to mount:
>
>  mount -t overlayfs overlayfs -olowerdir=/lower -oupperdir=/upper /overlay
>

OK, I built a small live CD with the v7 patch and I can boot it but I
get errors like

Cleaning up temporary files...
[    nn.nnnnnn] overlayfs: ERROR - failed to whiteout 'motd'
find: cannot delete `./motd': Operation not supported

Thanks

Michal
