Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab0ESRMP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 13:12:15 -0400
Received: from mail-pz0-f194.google.com ([209.85.222.194]:49179 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab0ESRMN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 13:12:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=xJl0y0k4d2++7S8J9BcgCC7HYIah4K7x6pERrR8fYmUkgsGyCyltkWG4j18vgZ8tN7
         33/hXF8tK5cRCeKQIHfjJM+RPrC0uDRMlOnkcu9yBZBU8ld5AYznSZCS25C43SXBCHfD
         4e1L01Z8Twi37pKJ9U3wBRbZHylkS5ejgZaqc=
MIME-Version: 1.0
In-Reply-To: <AANLkTim29sghIN6Xr-ZhjYN92iChYpmXODty12THu364@mail.gmail.com>
References: <h2h6d38d2f91004271023hc2d2b69ekbfd40fe97d5b2566@mail.gmail.com> 
	<y2u604760771004281000y3d80fe59v15871802d3d0d9f2@mail.gmail.com> 
	<r2r6d38d2f91004281555n6322c65dhe19b01a6dfe42771@mail.gmail.com> 
	<AANLkTil1Rr9IGxan8diaQNwNmFnljQs3w0j3oyQoGLgA@mail.gmail.com> 
	<AANLkTimSlLNf2b1YVBkUrFLM3PmRGmgVyBNMjNNccd8q@mail.gmail.com> 
	<AANLkTin3AJJRAV3HD0aKPbkG1oxrrl6uAO8aGQWgguw0@mail.gmail.com> 
	<AANLkTilJIhcCkRDw4UoQFIMxHbtvGodxKr7MtP1qFGxY@mail.gmail.com> 
	<AANLkTinybFoRb7FJE4yj8zy3Bgi_2dw6SFMkXWkt4c3x@mail.gmail.com> 
	<AANLkTilYTbyFLP4J91zOwckbsegA7-udGT8xGin4DCBO@mail.gmail.com> 
	<AANLkTim29sghIN6Xr-ZhjYN92iChYpmXODty12THu364@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 19 May 2010 10:11:53 -0700
Message-ID: <AANLkTiljPn9SXU_OR_SOR2r9WpDpJf2ybcbCpmxpV3WI@mail.gmail.com>
Subject: Re: Logitech Headset
To: Kevin McKinney <klmckinney1@gmail.com>
Cc: Daniel Chen <seven.steps@gmail.com>, kernel-team@lists.ubuntu.com,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 10:00 AM, Kevin McKinney <klmckinney1@gmail.com> wrote:
>> As I noted, I do not think there is a driver required, but I am also
>> not sure how the device exports its capabilities for microphone/audio
>> to the OS.
> Point well taken.. I can still use this for my final project;

How so? To describe how you didn't need a driver and how the
technology works in the background? You mean reverse engineering the
protocol ?

> unless you
> know of another device that requires a driver  :) ???

Yes, take a look at the staging area of the Linux kernel and port one
of those puppies over to proper after checking with the devel driver
list to see if someone is already not doing it. The nice thing with
this is you don't have to fight with a vendor already to get some code
out, the could would already be available to you and the code is in a
tree. All you'd have to do is fix it up for proper.

>> I was using an
>> older version of the kernel at that time
>> (2.6.27) http://kemnet.homelinux.com/lxr/source/2.6.27/.
>> That is dirt fucking old.
>
> LOL - I know, I will start using the most recent kernel.

No problem. Just noticed the headset looked similar to what I bought
so figured I'd chime in.

  Luis
