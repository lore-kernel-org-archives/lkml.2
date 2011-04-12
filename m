Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213Ab1DLUbp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 16:31:45 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51951 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756056Ab1DLUbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 16:31:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=apw79A0KAnzBdWXKn8st0ExCVoFgCaktcGErsaFh5muFkcIAOzzLE2vDX/pxFU2OWR
         RAPLZzSjd5Wwej26xWOiVxOsddxtKqwOFBVQx444aHzxdb7YxAw/Br0axV/dvX4Dg7S7
         PNxqWWMjftrzbvzSgPrNR0gOLXFiwHBWTsMvU=
Message-ID: <4DA4B6A8.7030804@gmail.com>
Date: Tue, 12 Apr 2011 16:31:36 -0400
From: Ric Wheeler <ricwheeler@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110403 Fedora/3.1.9-6.fc15 Thunderbird/3.1.9
MIME-Version: 1.0
To: Michal Suchanek <hramrach@centrum.cz>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>, Ian Kent <ikent@redhat.com>,
        Jeff Moyer <jmoyer@redhat.com>, miklos@szeredi.hu,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: Unionmount status?
References: <BANLkTini-g9XVOohKjwpZT-SGozcwx720A@mail.gmail.com>
In-Reply-To: <BANLkTini-g9XVOohKjwpZT-SGozcwx720A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2011 11:00 AM, Michal Suchanek wrote:
> Hello,
>
> as some already know the Unionmount VFS union which has been in
> development for some years now is the only True Union (TM) that can be
> accepted into the kernel mainline by the VFS maintainers (for reasons
> of their own which you can surely find if you search the web or ask
> them directly).
>
> The current UnionMount version that can be found here:
>
> http://git.kernel.org/?p=linux/kernel/git/val/linux-2.6.git;a=shortlog;h=refs/heads/ext2_works
>
> works for me as good as aufs does. That is I can build a live CD using
> this unioning solution and it boots and runs without any apparent
> issues.
>
> There are probably many possible uses of the union which I did not
> test nor did I test long term stability of using the unioned
> filesystem. As far as ephemeral live systems go it works fine for me,
> though.
>
> The issue is that while the code is (nearly) finished it is not yet
> merged into mainline and as I am not familiar with the details of
> ever-changing Linux VFS layer forward-porting this code to current
> kernels is somewhat challenging.
>
> What is the plan with unionmount now?
>
> What is required  for it to be merged into mainline?
>
> Thanks
>
> Michal

Hi Michal,

People are actively looking to see what union mount (or overlayfs) solution to 
pursue. Val has shifted her focus away from kernel hacking these days, but did 
refresh her patch set in the last month or so.

Miklos has an overlay file system that has also been posted upstream.

I think that testing like you did and getting more eyes to look at the code is 
the next key step for both projects.

Thanks!

Ric



