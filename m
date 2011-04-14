Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757149Ab1DNNVn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 09:21:43 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64649 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab1DNNVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 09:21:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=uJZZufhCi90cFW8Xo8M8eotBZcPRd7mVFkDaDMRdLJwZtdVMoR/PDlqUxMajnMSPX9
         s/fBMPfU04VN3sK4nHCxcOfVEQ70YcFYuIrA+dnIhohvLlMas7hy7/F3zXoe00ckZGm5
         BUyf9WQLEQVz+juupEKi+jOp8nrXjgT1O1qO4=
Message-ID: <4DA6F4E2.1060005@gmail.com>
Date: Thu, 14 Apr 2011 09:21:38 -0400
From: Ric Wheeler <ricwheeler@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.38.b3pre.fc13 Thunderbird/3.1.9
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>, Christoph Hellwig <hch@infradead.org>
CC: Michal Suchanek <hramrach@centrum.cz>, Ian Kent <ikent@redhat.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>, Jeff Moyer <jmoyer@redhat.com>
Subject: Re: Unionmount status?
References: <BANLkTini-g9XVOohKjwpZT-SGozcwx720A@mail.gmail.com>	<4DA4B6A8.7030804@gmail.com>	<BANLkTimsAE1ZAJhsSjnh3LqwsN9x0cLaXg@mail.gmail.com>	<4DA5DCB8.3040101@gmail.com>	<BANLkTineg2XYYOZAU9trrw=+-vH8McN_9w@mail.gmail.com>	<4DA5F569.9020309@gmail.com>	<BANLkTi=Z1CQm=u2Q1VCHfr=53n5qTC=7bA@mail.gmail.com>	<1302756608.2854.10.camel@perseus.themaw.net>	<BANLkTinff1NQ-iYevjccO7ADB9h4RH+mOQ@mail.gmail.com> <BANLkTimD9WB_RP1j8yJR7GUn_NuDuM2SHw@mail.gmail.com>
In-Reply-To: <BANLkTimD9WB_RP1j8yJR7GUn_NuDuM2SHw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2011 05:40 AM, Miklos Szeredi wrote:
> On Thu, Apr 14, 2011 at 11:32 AM, Michal Suchanek<hramrach@centrum.cz>  wrote:
>> I guess overlayfs includes the better part of unionmount and achieves
>> similar level of functionality in much smaller code size and is
>> actively developed.
>>
>> This might make it the best candidate for inclusion so far.
>>
>> It does not (yet?) support NFS which is one of the options commonly
>> used with union solutions, though.
> NFS is supported as a lower (read-only) layer, but not as an upper
> (read-write) layer.
>
> Thanks,
> Miklos
I am not that concerned with the state of Val's repo, her intention was to hand 
off the project cleanly to others and have them drive the code (that hand off 
was the posting of the patch set). Several people (Ian, David Howells and Al 
Viro) had been involved with union mounts recently, so we do have reasonable 
candidates for a hand off.

One of the concerns with unionfs is the duplication of data. Union mounts avoids 
this with that implementation. That might make unionfs more of a burden for very 
large file systems, but probably not a concern for many use cases.

The union mount patch set is certainly considerably larger.

Christoph had expressed some concerns about locking that I think it would be 
good to discuss again as well.

Ric



