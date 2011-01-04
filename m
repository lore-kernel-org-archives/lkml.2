Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751298Ab1ADLSY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 06:18:24 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57822 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781Ab1ADLSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 06:18:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=GvQHj5YgvEIOPD+muC/PvvAhdOKS9KkrfeGij27ob/OFm4CE7c6ycQInxVsyTWQuWk
         N1j/yJVgcVJ7nbQx9g8+wSzgYnKi4Y43Brm6zmKOmz/WSFyTZf3RPxLWP66T18njp6Ab
         LJLpm/t6ALK5xNwTb5+UKRBpVOXJAPoYG+ycA=
MIME-Version: 1.0
In-Reply-To: <20110104110841.GA12647@merkur.ravnborg.org>
References: <AANLkTins3HdRJ-Y7bCuXFjOhjx+-nxDHSqUxBPuuxFxg@mail.gmail.com>
	<alpine.DEB.2.00.1101040329450.7740@localhost6.localdomain6>
	<AANLkTinffZs-FD+PuBdavmiNpR4AK3T9eQ_EQaEqLtWB@mail.gmail.com>
	<20110104110841.GA12647@merkur.ravnborg.org>
Date: Tue, 4 Jan 2011 13:18:22 +0200
Message-ID: <AANLkTimx1GZvC30+9VJph-PCwbjKBH4_yL_VdY3vwcHE@mail.gmail.com>
Subject: Re: Kernel build
From: Anca Emanuel <anca.emanuel@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>,
        LKML <linux-kernel@vger.kernel.org>, kernel-team@lists.ubuntu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 4, 2011 at 1:08 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Tue, Jan 04, 2011 at 12:09:21PM +0200, Anca Emanuel wrote:
>> On Tue, Jan 4, 2011 at 10:30 AM, Robert P. J. Day <rpjday@crashcourse.ca> wrote:
>> > On Tue, 4 Jan 2011, Anca Emanuel wrote:
>> >
>> >> Question: Why I need to rebuild all the modules, if they are already builded.
>> >> https://wiki.ubuntu.com/KernelTeam/GitKernelBuild
>> >> If I make an one line change, I need to wait one hour to make an new
>> >> kernel on an intel core duo at 2GHz sistem ?
>
> make V=2 will tell you what file/config entry caused the rebuild to happen.
>
>>
>> This is not an kernelnewbies qestion.
>> This in an Google project question.
>> Search for it.
> I did. No luck. Any pointer?
http://lwn.net/Articles/420596/
clang

there are also some apple developers there...
