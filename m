Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073Ab1DOQbu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 12:31:50 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:59578 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab1DOQbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 12:31:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=sdS4Hcp6iBLNIgF0oCrdS4xlm0+qzStp3v0NV2lXxLzI6jDBrLts/Pf2u0IZB8yV8o
         tFm0dMctB0WM/s6/5wMnyRgvr+E/36VkYs58kPeensjuUPgYGePicMiau0ElKDP8+eCe
         iftTVbEJ21HnAinj2xiBZr4yY4tm0y7nf2rRI=
Message-ID: <4DA872F1.8080101@gmail.com>
Date: Fri, 15 Apr 2011 12:31:45 -0400
From: Ric Wheeler <ricwheeler@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.38.b3pre.fc13 Thunderbird/3.1.9
MIME-Version: 1.0
To: Michal Suchanek <hramrach@centrum.cz>
CC: Miklos Szeredi <miklos@szeredi.hu>, Christoph Hellwig <hch@infradead.org>,
        Ian Kent <ikent@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Jeff Moyer <jmoyer@redhat.com>
Subject: Re: Unionmount status?
References: <BANLkTini-g9XVOohKjwpZT-SGozcwx720A@mail.gmail.com> <4DA4B6A8.7030804@gmail.com> <BANLkTimsAE1ZAJhsSjnh3LqwsN9x0cLaXg@mail.gmail.com> <4DA5DCB8.3040101@gmail.com> <BANLkTineg2XYYOZAU9trrw=+-vH8McN_9w@mail.gmail.com> <4DA5F569.9020309@gmail.com> <BANLkTi=Z1CQm=u2Q1VCHfr=53n5qTC=7bA@mail.gmail.com> <1302756608.2854.10.camel@perseus.themaw.net> <BANLkTinff1NQ-iYevjccO7ADB9h4RH+mOQ@mail.gmail.com> <BANLkTimD9WB_RP1j8yJR7GUn_NuDuM2SHw@mail.gmail.com> <4DA6F4E2.1060005@gmail.com> <BANLkTik8uQ8keNHnmQCf=MTQK1Q-6=BK4Q@mail.gmail.com>
In-Reply-To: <BANLkTik8uQ8keNHnmQCf=MTQK1Q-6=BK4Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2011 10:54 AM, Michal Suchanek wrote:
> On 14 April 2011 15:21, Ric Wheeler<ricwheeler@gmail.com>  wrote:
>> On 04/14/2011 05:40 AM, Miklos Szeredi wrote:
>>> On Thu, Apr 14, 2011 at 11:32 AM, Michal Suchanek<hramrach@centrum.cz>
>>>   wrote:
>>>> I guess overlayfs includes the better part of unionmount and achieves
>>>> similar level of functionality in much smaller code size and is
>>>> actively developed.
>>>>
>>>> This might make it the best candidate for inclusion so far.
>>>>
>>>> It does not (yet?) support NFS which is one of the options commonly
>>>> used with union solutions, though.
>>> NFS is supported as a lower (read-only) layer, but not as an upper
>>> (read-write) layer.
>>>
>>> Thanks,
>>> Miklos
>> I am not that concerned with the state of Val's repo, her intention was to
>> hand off the project cleanly to others and have them drive the code (that
>> hand off was the posting of the patch set). Several people (Ian, David
>> Howells and Al Viro) had been involved with union mounts recently, so we do
>> have reasonable candidates for a hand off.
>>
>> One of the concerns with unionfs is the duplication of data. Union mounts
>> avoids this with that implementation. That might make unionfs more of a
>> burden for very large file systems, but probably not a concern for many use
>> cases.
> Just to make things clear, what is a very large filesystem?
>
> A heavily compressed DVD image?
>
> Tens or hundreds  of gigabytes? Terabytes?
>
> Hundreds, thousands or hundreds of thousands of inodes?
>
> Or is testing required to determine at what size the performance
> becomes unacceptable?
>
> Thanks
>
> Michal

Very large in the number of inodes more so than fs size...

Ric

