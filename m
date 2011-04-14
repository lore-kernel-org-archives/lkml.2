Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464Ab1DNOzE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 10:55:04 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37326 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203Ab1DNOzC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 10:55:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=TjLfZ6gjEhmkxeCTajQlugxJCWgO516y2hdrv+Bae9/0fLdrpHA1aHMunODNlSmlaz
         4NSlUp8liIjYJZjTGP57R1M0zMu5Mun7xpKpCAW61bczuAbBErl2j1D+XA+HZajzjja8
         iR8R+Ixp1mq/H6w+koj3FT0fCXlUiV/yzqBOc=
MIME-Version: 1.0
In-Reply-To: <4DA6F4E2.1060005@gmail.com>
References: <BANLkTini-g9XVOohKjwpZT-SGozcwx720A@mail.gmail.com>
 <4DA4B6A8.7030804@gmail.com> <BANLkTimsAE1ZAJhsSjnh3LqwsN9x0cLaXg@mail.gmail.com>
 <4DA5DCB8.3040101@gmail.com> <BANLkTineg2XYYOZAU9trrw=+-vH8McN_9w@mail.gmail.com>
 <4DA5F569.9020309@gmail.com> <BANLkTi=Z1CQm=u2Q1VCHfr=53n5qTC=7bA@mail.gmail.com>
 <1302756608.2854.10.camel@perseus.themaw.net> <BANLkTinff1NQ-iYevjccO7ADB9h4RH+mOQ@mail.gmail.com>
 <BANLkTimD9WB_RP1j8yJR7GUn_NuDuM2SHw@mail.gmail.com> <4DA6F4E2.1060005@gmail.com>
From: Michal Suchanek <hramrach@centrum.cz>
Date: Thu, 14 Apr 2011 16:54:41 +0200
X-Google-Sender-Auth: X7ZnmmBSRbI-ZqcvVGGv94k1ifI
Message-ID: <BANLkTik8uQ8keNHnmQCf=MTQK1Q-6=BK4Q@mail.gmail.com>
Subject: Re: Unionmount status?
To: Ric Wheeler <ricwheeler@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christoph Hellwig <hch@infradead.org>,
        Ian Kent <ikent@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Jeff Moyer <jmoyer@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 April 2011 15:21, Ric Wheeler <ricwheeler@gmail.com> wrote:
> On 04/14/2011 05:40 AM, Miklos Szeredi wrote:
>>
>> On Thu, Apr 14, 2011 at 11:32 AM, Michal Suchanek<hramrach@centrum.cz>
>>  wrote:
>>>
>>> I guess overlayfs includes the better part of unionmount and achieves
>>> similar level of functionality in much smaller code size and is
>>> actively developed.
>>>
>>> This might make it the best candidate for inclusion so far.
>>>
>>> It does not (yet?) support NFS which is one of the options commonly
>>> used with union solutions, though.
>>
>> NFS is supported as a lower (read-only) layer, but not as an upper
>> (read-write) layer.
>>
>> Thanks,
>> Miklos
>
> I am not that concerned with the state of Val's repo, her intention was to
> hand off the project cleanly to others and have them drive the code (that
> hand off was the posting of the patch set). Several people (Ian, David
> Howells and Al Viro) had been involved with union mounts recently, so we do
> have reasonable candidates for a hand off.
>
> One of the concerns with unionfs is the duplication of data. Union mounts
> avoids this with that implementation. That might make unionfs more of a
> burden for very large file systems, but probably not a concern for many use
> cases.

Just to make things clear, what is a very large filesystem?

A heavily compressed DVD image?

Tens or hundreds  of gigabytes? Terabytes?

Hundreds, thousands or hundreds of thousands of inodes?

Or is testing required to determine at what size the performance
becomes unacceptable?

Thanks

Michal
