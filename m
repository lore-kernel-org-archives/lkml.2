Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932654Ab1DLVhA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 17:37:00 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62099 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932568Ab1DLVg7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 17:36:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=RwSF0XFpHTziECPd2nsGMcG5q/yDBAqFhJhdX1vlVSqA8l+n95RcJeNdJOfqo3ztnJ
         Ef0x0ZlTLIdgOe3xfrLvHM6fLUNUuAnBf3UvV4soy3adgC7j8Qb2r1HrOel9L5Ug0mF7
         0GVyInv3JpFIjMjenTcbSiVVIWMwee7YRaigs=
MIME-Version: 1.0
In-Reply-To: <4DA4B6A8.7030804@gmail.com>
References: <BANLkTini-g9XVOohKjwpZT-SGozcwx720A@mail.gmail.com> <4DA4B6A8.7030804@gmail.com>
From: Michal Suchanek <hramrach@centrum.cz>
Date: Tue, 12 Apr 2011 23:36:38 +0200
X-Google-Sender-Auth: yCxcrxLiXwxLM4ns6N3H7kgQ-ps
Message-ID: <BANLkTimsAE1ZAJhsSjnh3LqwsN9x0cLaXg@mail.gmail.com>
Subject: Re: Unionmount status?
To: Ric Wheeler <ricwheeler@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>, Ian Kent <ikent@redhat.com>,
        Jeff Moyer <jmoyer@redhat.com>, miklos@szeredi.hu,
        Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 April 2011 22:31, Ric Wheeler <ricwheeler@gmail.com> wrote:
> On 04/12/2011 11:00 AM, Michal Suchanek wrote:
>>
>> Hello,
>>
>> as some already know the Unionmount VFS union which has been in
>> development for some years now is the only True Union (TM) that can be
>> accepted into the kernel mainline by the VFS maintainers (for reasons
>> of their own which you can surely find if you search the web or ask
>> them directly).
>>
>> The current UnionMount version that can be found here:
>>
>>
>> http://git.kernel.org/?p=linux/kernel/git/val/linux-2.6.git;a=shortlog;h=refs/heads/ext2_works
>>
>> works for me as good as aufs does. That is I can build a live CD using
>> this unioning solution and it boots and runs without any apparent
>> issues.
>>
>> There are probably many possible uses of the union which I did not
>> test nor did I test long term stability of using the unioned
>> filesystem. As far as ephemeral live systems go it works fine for me,
>> though.
>>
>> The issue is that while the code is (nearly) finished it is not yet
>> merged into mainline and as I am not familiar with the details of
>> ever-changing Linux VFS layer forward-porting this code to current
>> kernels is somewhat challenging.
>>
>> What is the plan with unionmount now?
>>
>> What is required  for it to be merged into mainline?
>>
>> Thanks
>>
>> Michal
>
> Hi Michal,
>
> People are actively looking to see what union mount (or overlayfs) solution
> to pursue. Val has shifted her focus away from kernel hacking these days,
> but did refresh her patch set in the last month or so.

I am not aware of such refreshed patch set, at least it is not
published in her repo.

>
> Miklos has an overlay file system that has also been posted upstream.

I have no idea about his other overlay filesystem either.

>
> I think that testing like you did and getting more eyes to look at the code
> is the next key step for both projects.
>

Could you provide more details?

I am not following the Linux fs development closely.

Thanks

Michal
