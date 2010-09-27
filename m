Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759732Ab0I0RFV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 13:05:21 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57187 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759406Ab0I0RFT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 13:05:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ksv3s/3GlO+k51YNaPDCqsQel5aC2I9cOa4qZVF7FZrX1ymEZIMGj99G3b/jdAPQow
         nYpaZ7K3f3epo/djb4yrr0NWnge+NH0iOkkCXeuDYshLVSBmQlZwaa5TIyVyt2unq7Hr
         PyggViTRZ4YQCQj93vlAo5rwZw+IJq2e/9vec=
MIME-Version: 1.0
In-Reply-To: <20100927013152.GA21139@suse.de>
References: <20100927003608.GA20395@kroah.com>
	<AANLkTikHtuXhMtjudLTUMPR7uL9eGGePUP93MqFLTfb5@mail.gmail.com>
	<20100927013152.GA21139@suse.de>
Date: Mon, 27 Sep 2010 20:05:17 +0300
Message-ID: <AANLkTim9hkqCbndaaNT3wME6tj+bvpVE6GrgibZjNO5G@mail.gmail.com>
Subject: Re: Linux 2.6.35.6
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 4:31 AM, Greg KH <gregkh@suse.de> wrote:
> On Mon, Sep 27, 2010 at 04:00:51AM +0300, Felipe Contreras wrote:
>> Can you add a 'master' branch that points to the latest tag? That
>> would make things easier for other people, specially the ones that
>> just do 'git pull'.
>
> I don't understand, this works for me this way, the master branch _is_
> the latest version at all times.  Did you just need to wait a few
> minutes to have the mirror catch up?

It wasn't about timing: 'git branch -a' didn't show any remote branch.
Anyway, I tried cloning from scratch, and cloning with a template and
the branch was there. Also, I tried removing and creating the remote
again and voila; the branch is not there. But have been a weird git
bug.

Sorry for the noise.

-- 
Felipe Contreras
