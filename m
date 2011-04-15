Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291Ab1DOMek (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 08:34:40 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48920 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab1DOMei convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 08:34:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=HP/zaPOQ4mpjWo/ztotSQDpUD7UDPTLKqafz3SFEkdkbU9Qfbcf5ySVqnBCmK90UaJ
         aDdGGrNU2mR4Eg9j7XEhtoSDi5IGfeeJbxGK/cONWaKtB1zH8A62jtGwZNLrXUASCxqd
         uT/IfsxOL3hbX+u+RUX97FyniH0OO4qFcQnEE=
MIME-Version: 1.0
In-Reply-To: <BANLkTikUe_2Uo2_tSYdfNoNXKYO4Bj30iQ@mail.gmail.com>
References: <BANLkTini-g9XVOohKjwpZT-SGozcwx720A@mail.gmail.com>
 <4DA4B6A8.7030804@gmail.com> <BANLkTimsAE1ZAJhsSjnh3LqwsN9x0cLaXg@mail.gmail.com>
 <alpine.LRH.2.00.1104131618170.6953@twin.jikos.cz> <BANLkTindBULU9KAVWPJQ7oQvfCNQU-BuAg@mail.gmail.com>
 <BANLkTin6CVFOAECWwYg3B5V2AfscFfjt8w@mail.gmail.com> <BANLkTik7jasnvqFQohRdU-3crM8fr9pBXg@mail.gmail.com>
 <BANLkTikF_hgYSaZJbZosWwcs715tLXYfmQ@mail.gmail.com> <BANLkTikTUo17RncV7bushPTri=LEykep5g@mail.gmail.com>
 <BANLkTikUe_2Uo2_tSYdfNoNXKYO4Bj30iQ@mail.gmail.com>
From: Michal Suchanek <hramrach@centrum.cz>
Date: Fri, 15 Apr 2011 14:34:18 +0200
X-Google-Sender-Auth: UmegOqUNWJ_9lyd7-49atoZ6mg8
Message-ID: <BANLkTikHKGLQvShJBL0P7XJ9XQ3EpgYxuQ@mail.gmail.com>
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

On 15 April 2011 14:29, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Fri, Apr 15, 2011 at 1:51 PM, Michal Suchanek <hramrach@centrum.cz> wrote:
>> On 15 April 2011 13:31, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>> On Fri, Apr 15, 2011 at 1:22 PM, Michal Suchanek <hramrach@centrum.cz> wrote:
>>>>
>>>> Cleaning up temporary files...
>>>> [    nn.nnnnnn] overlayfs: ERROR - failed to whiteout 'motd'
>>>> find: cannot delete `./motd': Operation not supported
>>>
>>> What is the upper filesystem type?  Is xattr support enabled?
>>>
>>
>> The upper filesystem is tmpfs and there is not option regarding XATTR
>> in the config.
>
> Apparently tmpfs does not support generic xattr.  I understand why
> tmpfs is an attractive choice for an upper filesystem, so this should
> be addressed.
>
> I see two options here:
>
> 1) implement generic xattr in tmpfs

IMHO this is a general feature that keeps overlayfs in itself clean
and small and can benefit other uses of tmpfs.

> 2) take whiteout/opaque support from union mounts and use that

How far from importing full unionmount is that?

Thanks

Michal
