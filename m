Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab0ESQeu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 12:34:50 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:58017 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382Ab0ESQes convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 12:34:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=ENwR65vSpSzyRtWG4wFkZqVa+j66t4gfWsGjKQu3vgmMFVOutioa0GGCO3HorFFepj
         rxjerUL5lU1o1ZaRM6jxbTKfSYrggrdFqGxTO51SnUELWkjKenlh964gKh1YlDuHIvo2
         pg6yX9hnhxrCb4rS4obuzPiZdyHyIZ2c/vuwo=
MIME-Version: 1.0
In-Reply-To: <AANLkTinybFoRb7FJE4yj8zy3Bgi_2dw6SFMkXWkt4c3x@mail.gmail.com>
References: <h2h6d38d2f91004271023hc2d2b69ekbfd40fe97d5b2566@mail.gmail.com> 
	<1272473196.1827.91.camel@lenovo> <y2u604760771004281000y3d80fe59v15871802d3d0d9f2@mail.gmail.com> 
	<r2r6d38d2f91004281555n6322c65dhe19b01a6dfe42771@mail.gmail.com> 
	<AANLkTil1Rr9IGxan8diaQNwNmFnljQs3w0j3oyQoGLgA@mail.gmail.com> 
	<AANLkTimSlLNf2b1YVBkUrFLM3PmRGmgVyBNMjNNccd8q@mail.gmail.com> 
	<AANLkTin3AJJRAV3HD0aKPbkG1oxrrl6uAO8aGQWgguw0@mail.gmail.com> 
	<AANLkTilJIhcCkRDw4UoQFIMxHbtvGodxKr7MtP1qFGxY@mail.gmail.com> 
	<AANLkTinybFoRb7FJE4yj8zy3Bgi_2dw6SFMkXWkt4c3x@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 19 May 2010 09:34:27 -0700
Message-ID: <AANLkTilYTbyFLP4J91zOwckbsegA7-udGT8xGin4DCBO@mail.gmail.com>
Subject: Re: Logitech Headset
To: Kevin McKinney <klmckinney1@gmail.com>
Cc: Daniel Chen <seven.steps@gmail.com>, kernel-team@lists.ubuntu.com,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 9:10 AM, Kevin McKinney <klmckinney1@gmail.com> wrote:
> Luis,
> Yes, I tried it about two months ago with not luck. I also performed a grep
> on the source code and did not find the device ID specified.

As I noted, I do not think there is a driver required, but I am also
not sure how the device exports its capabilities for microphone/audio
to the OS.

> I was using an
> older version of the kernel at that time
> (2.6.27) http://kemnet.homelinux.com/lxr/source/2.6.27/.

That is dirt fucking old.

> I will try again
> and post my results. Any other tips, concerns, or questions is appreciated.
> I still consider myself new to the linux kernel / Ubuntu. I have only been
> studying and using it for about three years now.

  Luis
