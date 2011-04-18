Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217Ab1DRNiU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 09:38:20 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:35782 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324Ab1DRNiN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 09:38:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=qwZJf+lER2qc1poOArS4b6zTJAH8Iv/palW6lqVsWkzinIkW8uhmLfegZsipKiq30v
         B3XShc3UPr7O8fXVQDmbb6XUYSv9E0Ke8tbHh/b8rE6seymYMOHAlFa4MF58TpjnJIYL
         ZCAyg7xq/72+MYFyYcppt6r1sEEId5ISuAeiY=
MIME-Version: 1.0
In-Reply-To: <C450CD68-10AE-4527-B6BF-A5D5F0BF005F@dilger.ca>
References: <BANLkTini-g9XVOohKjwpZT-SGozcwx720A@mail.gmail.com>
 <4DA4B6A8.7030804@gmail.com> <BANLkTimsAE1ZAJhsSjnh3LqwsN9x0cLaXg@mail.gmail.com>
 <alpine.LRH.2.00.1104131618170.6953@twin.jikos.cz> <BANLkTindBULU9KAVWPJQ7oQvfCNQU-BuAg@mail.gmail.com>
 <BANLkTin6CVFOAECWwYg3B5V2AfscFfjt8w@mail.gmail.com> <BANLkTik7jasnvqFQohRdU-3crM8fr9pBXg@mail.gmail.com>
 <BANLkTikF_hgYSaZJbZosWwcs715tLXYfmQ@mail.gmail.com> <BANLkTikTUo17RncV7bushPTri=LEykep5g@mail.gmail.com>
 <BANLkTikUe_2Uo2_tSYdfNoNXKYO4Bj30iQ@mail.gmail.com> <C450CD68-10AE-4527-B6BF-A5D5F0BF005F@dilger.ca>
From: Michal Suchanek <hramrach@centrum.cz>
Date: Mon, 18 Apr 2011 15:37:53 +0200
X-Google-Sender-Auth: JCImp13Z02P0eK1NMV5ZlpCYiwM
Message-ID: <BANLkTinf3nTLt4QStFF6tJ4mb8zKvKUw1Q@mail.gmail.com>
Subject: Re: Unionmount status?
To: Andreas Dilger <adilger@dilger.ca>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jiri Kosina <jkosina@suse.cz>,
        Ric Wheeler <ricwheeler@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Ian Kent <ikent@redhat.com>, Jeff Moyer <jmoyer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 April 2011 00:18, Andreas Dilger <adilger@dilger.ca> wrote:
> On 2011-04-15, at 6:29 AM, Miklos Szeredi wrote:
>> Apparently tmpfs does not support generic xattr.  I understand why
>> tmpfs is an attractive choice for an upper filesystem, so this should
>> be addressed.
>>
>> I see two options here:
>>
>> 1) implement generic xattr in tmpfs
>
> There was a patch posted recently to add xattr support to tmpfs, so that it can use security labels:
>
> From: Eric Paris <eparis@redhat.com>
> Subject: [PATCH] tmpfs: implement xattr support for the entire security namespace
> Date: March 29, 2011 12:56:49 PM MDT
>
> Cheers, Andreas

Applying this patch is not sufficient. Apparently more xattrs are
needed but adding them on top of this patch should be easy.

The ones mentioned in the overlayfs doc are

trusted.overlay.whiteout
trusted.overlay.opaque

The patch implements security.*

Thanks

Michal
