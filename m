Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078Ab1DOLvd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 07:51:33 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49500 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508Ab1DOLvc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 07:51:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=LOXe2Z9ef2aRUCoafnZ+b+f/1p3ln1C07wQ6YOVw4nowqmO3Nf2jmCGSZ8e2kT5HbE
         ccdH/sZm/IFIuzypGnkrYcuNHC/tEDXTMXxGvofMcu9feo9kYifsnWESTcdoioVkPwpy
         HcnLL98cPxluLN3EUwaPAPssnSyZdKQWDKsgE=
MIME-Version: 1.0
In-Reply-To: <BANLkTikF_hgYSaZJbZosWwcs715tLXYfmQ@mail.gmail.com>
References: <BANLkTini-g9XVOohKjwpZT-SGozcwx720A@mail.gmail.com>
 <4DA4B6A8.7030804@gmail.com> <BANLkTimsAE1ZAJhsSjnh3LqwsN9x0cLaXg@mail.gmail.com>
 <alpine.LRH.2.00.1104131618170.6953@twin.jikos.cz> <BANLkTindBULU9KAVWPJQ7oQvfCNQU-BuAg@mail.gmail.com>
 <BANLkTin6CVFOAECWwYg3B5V2AfscFfjt8w@mail.gmail.com> <BANLkTik7jasnvqFQohRdU-3crM8fr9pBXg@mail.gmail.com>
 <BANLkTikF_hgYSaZJbZosWwcs715tLXYfmQ@mail.gmail.com>
From: Michal Suchanek <hramrach@centrum.cz>
Date: Fri, 15 Apr 2011 13:51:11 +0200
X-Google-Sender-Auth: DJ1NLoj3_CSXn8oqRA14ePJgrmc
Message-ID: <BANLkTikTUo17RncV7bushPTri=LEykep5g@mail.gmail.com>
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

On 15 April 2011 13:31, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Fri, Apr 15, 2011 at 1:22 PM, Michal Suchanek <hramrach@centrum.cz> wrote:
>> On 14 April 2011 10:38, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>> On Wed, Apr 13, 2011 at 5:13 PM, Michal Suchanek <hramrach@centrum.cz> wrote:
>>>> On 13 April 2011 16:18, Jiri Kosina <jkosina@suse.cz> wrote:
>>>>> https://lkml.org/lkml/2011/3/22/222
>>>>>
>>>>
>>>> Thanks for pointing out this announcement.
>>>>
>>>> However, neither this announcement nor the document
>>>> Documentation/filesystems/overlayfs.txt included in the git tree
>>>> details how to mount the filesystem. Without that it is kind of
>>>> useless.
>>>
>>> Oh, I'll fix that in the docs.  Thanks for pointing it out.
>>>
>>> Here's how to mount:
>>>
>>>  mount -t overlayfs overlayfs -olowerdir=/lower -oupperdir=/upper /overlay
>>>
>>
>> OK, I built a small live CD with the v7 patch and I can boot it but I
>> get errors like
>>
>> Cleaning up temporary files...
>> [    nn.nnnnnn] overlayfs: ERROR - failed to whiteout 'motd'
>> find: cannot delete `./motd': Operation not supported
>
> What is the upper filesystem type?  Is xattr support enabled?
>

The upper filesystem is tmpfs and there is not option regarding XATTR
in the config.

Thanks

Michal
