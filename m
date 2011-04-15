Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028Ab1DOLb3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 07:31:29 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37548 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab1DOLb2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 07:31:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=szeredi.hu; s=google;
        h=mime-version:x-originating-ip:in-reply-to:references:date
         :message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=N5TJgcpD5bcEJvi2/5wMGkDHmPyWGjyd8yZNVcCSL+xPwh6jrDcUpB7cYAmZOfjCDV
         DnP1oabd1x+GnQ2cW75IAaUrjHrLRj2au/Heu8VjyCqIezG8xDtei89rOLSOMwY1IzaQ
         KIduqV/pQeJAbQiHPg7gvMTpMcxC51rTQpq5I=
MIME-Version: 1.0
X-Originating-IP: [88.209.222.127]
In-Reply-To: <BANLkTik7jasnvqFQohRdU-3crM8fr9pBXg@mail.gmail.com>
References: <BANLkTini-g9XVOohKjwpZT-SGozcwx720A@mail.gmail.com>
	<4DA4B6A8.7030804@gmail.com>
	<BANLkTimsAE1ZAJhsSjnh3LqwsN9x0cLaXg@mail.gmail.com>
	<alpine.LRH.2.00.1104131618170.6953@twin.jikos.cz>
	<BANLkTindBULU9KAVWPJQ7oQvfCNQU-BuAg@mail.gmail.com>
	<BANLkTin6CVFOAECWwYg3B5V2AfscFfjt8w@mail.gmail.com>
	<BANLkTik7jasnvqFQohRdU-3crM8fr9pBXg@mail.gmail.com>
Date: Fri, 15 Apr 2011 13:31:26 +0200
Message-ID: <BANLkTikF_hgYSaZJbZosWwcs715tLXYfmQ@mail.gmail.com>
Subject: Re: Unionmount status?
From: Miklos Szeredi <miklos@szeredi.hu>
To: Michal Suchanek <hramrach@centrum.cz>
Cc: Jiri Kosina <jkosina@suse.cz>, Ric Wheeler <ricwheeler@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>, Ian Kent <ikent@redhat.com>,
        Jeff Moyer <jmoyer@redhat.com>, Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 15, 2011 at 1:22 PM, Michal Suchanek <hramrach@centrum.cz> wrote:
> On 14 April 2011 10:38, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Wed, Apr 13, 2011 at 5:13 PM, Michal Suchanek <hramrach@centrum.cz> wrote:
>>> On 13 April 2011 16:18, Jiri Kosina <jkosina@suse.cz> wrote:
>>>> https://lkml.org/lkml/2011/3/22/222
>>>>
>>>
>>> Thanks for pointing out this announcement.
>>>
>>> However, neither this announcement nor the document
>>> Documentation/filesystems/overlayfs.txt included in the git tree
>>> details how to mount the filesystem. Without that it is kind of
>>> useless.
>>
>> Oh, I'll fix that in the docs.  Thanks for pointing it out.
>>
>> Here's how to mount:
>>
>>  mount -t overlayfs overlayfs -olowerdir=/lower -oupperdir=/upper /overlay
>>
>
> OK, I built a small live CD with the v7 patch and I can boot it but I
> get errors like
>
> Cleaning up temporary files...
> [    nn.nnnnnn] overlayfs: ERROR - failed to whiteout 'motd'
> find: cannot delete `./motd': Operation not supported

What is the upper filesystem type?  Is xattr support enabled?

Thanks,
Miklos
