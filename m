Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563Ab0ESPx4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 11:53:56 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63828 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280Ab0ESPxy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 11:53:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=BrtioebfdYzZGccQv520WjODlJC11xJps5WJzAMfMZQd5eC8MlL+DPLzgpibZ0wXZJ
         xMj4ROwerWKQdEUOOegw1WCb7QGh/S8SsO85H/WJi4z5rD2RpYcHgHmJrlBdigzBM6vE
         EZ/VwcAFh0Bulk43tuEFt9m2hDqooaVKGV3H0=
MIME-Version: 1.0
In-Reply-To: <AANLkTin3AJJRAV3HD0aKPbkG1oxrrl6uAO8aGQWgguw0@mail.gmail.com>
References: <h2h6d38d2f91004271023hc2d2b69ekbfd40fe97d5b2566@mail.gmail.com> 
	<1272473196.1827.91.camel@lenovo> <y2u604760771004281000y3d80fe59v15871802d3d0d9f2@mail.gmail.com> 
	<r2r6d38d2f91004281555n6322c65dhe19b01a6dfe42771@mail.gmail.com> 
	<AANLkTil1Rr9IGxan8diaQNwNmFnljQs3w0j3oyQoGLgA@mail.gmail.com> 
	<AANLkTimSlLNf2b1YVBkUrFLM3PmRGmgVyBNMjNNccd8q@mail.gmail.com> 
	<AANLkTin3AJJRAV3HD0aKPbkG1oxrrl6uAO8aGQWgguw0@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 19 May 2010 08:53:33 -0700
Message-ID: <AANLkTilJIhcCkRDw4UoQFIMxHbtvGodxKr7MtP1qFGxY@mail.gmail.com>
Subject: Re: Logitech Headset
To: Kevin McKinney <klmckinney1@gmail.com>
Cc: Daniel Chen <seven.steps@gmail.com>, kernel-team@lists.ubuntu.com,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18, 2010 at 6:27 PM, Kevin McKinney <klmckinney1@gmail.com> wrote:
> Dan, thanks for the info, I was thinking I could leverage code from an
> existing driver with similar functionality.
>
> By the way, the advisor will NOT require any work.  The primary
> responsibility of the advisor is to verify the requirements.  That is,
> making sure the developed driver actually works.
>
> Anybody willing to verify the finished product can serve as the advisor.  If
> I have any technical questions while developing the driver, I will post them
> to the entire open source community. Please let me know if anyone is
> interested.

Stupid question, have you tried plugging the device in to verify it is
indeed not supported? I have a Logitech headset with USB vendor:device
ID 046d:0a12 (yours is 046d:0a01) and it works like a charm. I believe
the device works using its own protocol and embedded firmware, it does
not need a driver. Not sure how the device exposes the audio/input
functionality to the OS yet but it does.

  Luis
