Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932802Ab0JHSJP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 14:09:15 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38677 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758997Ab0JHSJN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 14:09:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MTfep+7eqcnoL+SjLkBqImEXn5c2GoGgyJo6nwv+TKfzkVpXHVHXeDwQSeaoQzoFPz
         Esutxwef/WI7ME6wzWRdKBMW7KoiVLaNnrPxwdTSRGoIJ6GJz9Brk9hA/oFVqiUcf2Ds
         sfHaCTz5zp5gnQi+Za48EJFMvvcObtDTE7Kfc=
MIME-Version: 1.0
In-Reply-To: <20101008134654.GA6600@kroah.com>
References: <AANLkTi=Hc2eWzOQ_xKBYsqfwkkiKGU0v42jUhLQ8K7dU@mail.gmail.com>
	<AANLkTinynZj9bYFAyfRTF2uopmLe6Ls4YGdZPqCAJTpR@mail.gmail.com>
	<20101008134654.GA6600@kroah.com>
Date: Fri, 8 Oct 2010 11:09:11 -0700
Message-ID: <AANLkTi=9N4e7fBekOaUa7OmPcaqicAgkC2aDT0HbJE8p@mail.gmail.com>
Subject: Re: [PATCH 00/33] Staging: Fixed <module-objs> to <module>-y
From: matt mooney <mfmooney@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: T Dent <tdent48227@gmail.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, sam@ravnborg.org,
        linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 8, 2010 at 6:46 AM, Greg KH <greg@kroah.com> wrote:
> On Fri, Oct 08, 2010 at 12:16:35AM -0700, matt mooney wrote:
>> On Thu, Oct 7, 2010 at 6:35 PM, T Dent <tdent48227@gmail.com> wrote:
>> > I patch against the next-20101006 tree.
>> >
>> > The patch series replace use of <module>-objs with <module>-y in the
>> > staging directory.
>>
>> Commit messages are written in the present tense. You happen to be
>> using two different tenses within the commit message, which is truly
>> odd.  And why did you not split apart those atrocious statements with
>> the infinite column width?
>
> As Dan said, we understand what is happening here, and we do not have
> grammer police for changelog comments, thank goodness.
>
>> This patch series adds little benefit.  As Sam has suggested, a more
>> general cleanup would be a better goal, and staging is an area that
>> needs extra attention some of which has already been pointed out in
>> other emails.
>
> But these patches are all good to have, so I will be applying them,
> please don't think they are unwanted at all.
>

This is good to know. I wonder how well received these changes will be
in other parts of the kernel though. I purposefully started in a
subsystem you maintain since I figured any criticism from you would be
constructive and you wouldn't just knack without reason.

Thanks,
mfm


-- 
GPG-Key: 9AFE00EA
