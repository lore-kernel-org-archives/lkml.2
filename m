Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377Ab1DOVsd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 17:48:33 -0400
Received: from smtp-out.google.com ([74.125.121.67]:54106 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757160Ab1DOVsc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 17:48:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kNQUtT17vNceN00/RplrGErg8s0NGldncVukKaEcIWgiwomuHCvUS0k906AOtqxFme
         1q5ulzEcM/ot2stgTD0A==
MIME-Version: 1.0
In-Reply-To: <BANLkTikUe_2Uo2_tSYdfNoNXKYO4Bj30iQ@mail.gmail.com>
References: <BANLkTini-g9XVOohKjwpZT-SGozcwx720A@mail.gmail.com>
	<4DA4B6A8.7030804@gmail.com>
	<BANLkTimsAE1ZAJhsSjnh3LqwsN9x0cLaXg@mail.gmail.com>
	<alpine.LRH.2.00.1104131618170.6953@twin.jikos.cz>
	<BANLkTindBULU9KAVWPJQ7oQvfCNQU-BuAg@mail.gmail.com>
	<BANLkTin6CVFOAECWwYg3B5V2AfscFfjt8w@mail.gmail.com>
	<BANLkTik7jasnvqFQohRdU-3crM8fr9pBXg@mail.gmail.com>
	<BANLkTikF_hgYSaZJbZosWwcs715tLXYfmQ@mail.gmail.com>
	<BANLkTikTUo17RncV7bushPTri=LEykep5g@mail.gmail.com>
	<BANLkTikUe_2Uo2_tSYdfNoNXKYO4Bj30iQ@mail.gmail.com>
Date: Fri, 15 Apr 2011 14:48:26 -0700
Message-ID: <BANLkTimNkLZzeRRMyFSp+m8WWtqp_zjFCg@mail.gmail.com>
Subject: Re: Unionmount status?
From: Hugh Dickins <hughd@google.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Michal Suchanek <hramrach@centrum.cz>, Jiri Kosina <jkosina@suse.cz>,
        Ric Wheeler <ricwheeler@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Ian Kent <ikent@redhat.com>, Jeff Moyer <jmoyer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>, Eric Paris <eparis@redhat.com>,
        James Morris <jmorris@namei.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 15, 2011 at 5:29 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
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
> 2) take whiteout/opaque support from union mounts and use that
>
> Both have advantages and disadvantages.
>
> Any thoughts?

Please get together with Eric: he's having trouble whipping up
enthusiasm for his tmpfs xattr patch, he and I would both appreciate
your support (and if I've persuaded him to leave out a part of it that
you would need, join forces to call me an idiot).  Mainly I'm hoping
to hear from hch and jmorris on it, being xattr-illiterate myself.

https://lkml.org/lkml/2011/3/29/302

Hugh
