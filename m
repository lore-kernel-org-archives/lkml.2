Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105Ab1D0LKx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 07:10:53 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46949 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab1D0LKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 07:10:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=KfyhbFljOjBiqJCh+u0BDJLvUQUcUA/cdY1kjITWNhnj0lLLmfolQbN4Yx5mYlmcsH
         niVAckY43ekue507JATLXuPjD9muqoPHle61bVVnamwEP5WAenTA5Om2HyEWpLgPWEyO
         5NonWG0ce26Gl1CrkjSV3G3djTZYeZCDW6Qeg=
MIME-Version: 1.0
In-Reply-To: <BANLkTimdaH5=q8M1bLCUTQ8aXJp4N1Dvyw@mail.gmail.com>
References: <201103311704.40372.roucaries.bastien@gmail.com>
	<BANLkTikmtyyMes84rED5wpMxuN8kL91jEw@mail.gmail.com>
	<4D9B3C10.9060704@suse.com>
	<BANLkTi=XDzOcZsP+aKS_WQSRxT+N8XHBRQ@mail.gmail.com>
	<BANLkTi=yTfMiLvVtZTqQvxVhy7aFPdwSXQ@mail.gmail.com>
	<BANLkTi=KUMNWJZZBQSHK+WViy6BYv8+4dQ@mail.gmail.com>
	<BANLkTi=LHx-cwQ8dAY7ogLN0B5xtJApVWg@mail.gmail.com>
	<20110411231843.GB2061@nowhere>
	<BANLkTinHk7fVi62_Xftwn_0WLOzkS4jggw@mail.gmail.com>
	<BANLkTikjD9hRPagnvjYO7A3ESGrwd1Qe-Q@mail.gmail.com>
	<20110426152908.GA2879@nowhere>
	<BANLkTimdaH5=q8M1bLCUTQ8aXJp4N1Dvyw@mail.gmail.com>
Date: Wed, 27 Apr 2011 13:10:51 +0200
Message-ID: <BANLkTinSNhdGU0pcCERCUeQA-Ba2VZHNeg@mail.gmail.com>
Subject: Re: Reiserfs deadlock in 2.6.36
From: Bastien ROUCARIES <roucaries.bastien@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>, solstice.dhiver@gmail.com
Cc: Jeff Mahoney <jeffm@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems also that  <solstice.dhiver@gmail.com> is hitting the same bug...

Bastien

On Wed, Apr 27, 2011 at 1:08 PM, Bastien ROUCARIES
<roucaries.bastien@gmail.com> wrote:
> On Tue, Apr 26, 2011 at 5:29 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>> On Mon, Apr 18, 2011 at 10:01:48AM +0200, Bastien ROUCARIES wrote:
>>> On Tue, Apr 12, 2011 at 2:01 PM, Bastien ROUCARIES
>>> <roucaries.bastien@gmail.com> wrote:
>>> > On Tue, Apr 12, 2011 at 1:18 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>>> >> On Mon, Apr 11, 2011 at 10:40:18AM +0200, Bastien ROUCARIES wrote:
>>> >>> Any news ? Can I test some patch ?
>>> Do you achieve to reproduce it ?
>>>
>>> Do you want I test something ?
>>
>> So I've run 8 parallel loops of git reset / git merge in 8 different
>> repos during 2 days but I've been unable to reproduce.
>>
>> I'm going to retry the same with kmail. What kind of thing do you make
>> with kmail for this to trigger? Can you also resend me your config
>> because I can't retrieve it from our discussion.
>
> I only retrieve every minutes a big imap account on gmail.
> I do nothing else
>
> The config is the same than debian standard kernel + debug reiserfs
> option. Arch is amd64. Will send you in reply of this email
>
> Thanks for trying to reproduce.
>
> Note that my home directory (where lockup occurs frequently has
> rw,nosuid,nodev,relatime,user_xattr,acl options.
>
> May be this bug is trigered by combinaison of relatime and acl ?
>
>> Thanks.
>>
>
