Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761Ab1ERJGp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 05:06:45 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:49102 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756587Ab1ERJGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 05:06:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=hFSW4vQd3ZhxKFT6M4WL0QTRE23uPUS2cIu3bFYmx+EweZah50delSFDaXDpufF2Nl
         L2+SRTEXEfnhRXPLzKEs/X9vkSKviO9y8u8n7CfPTZ0ISb+rPetomF+hWzEVRZk3d3aH
         PRd3EE8SS4xAFbLVY5zb9/jp6m5Ao6lExrN5s=
MIME-Version: 1.0
In-Reply-To: <20110518084535.GA24682@ritirata.org>
References: <20110518084535.GA24682@ritirata.org>
Date: Wed, 18 May 2011 12:06:42 +0300
Message-ID: <BANLkTi=sahmmHj_4bt=QhhFrRUELppjQVg@mail.gmail.com>
Subject: Re: Suggestion for patch: Comparison between packet sequence numbers
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Antonio Quartulli <ordex@autistici.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 11:45 AM, Antonio Quartulli <ordex@autistici.org> wrote:
> I would like to send a patch that introduces a little set of global defines
> that manages comparison between packet sequence numbers (considering
> overflow/wraparound). But honestly, I didn't find the right header where to
> add these defines.
>
> Could someone suggest me something?

It depends on where your comparison functions(?) are.
Add them somewhere, send a patch, what exactly patch does is far
more important than some define placement you can change at any time.
