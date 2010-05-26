Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880Ab0EZQdm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 12:33:42 -0400
Received: from mail-pz0-f176.google.com ([209.85.222.176]:37452 "EHLO
	mail-pz0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab0EZQdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 12:33:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=TzxbbnpoNOtJTjvJFEPufeZSwH8HBWig8SeHng2YHxoW6H45xKS/mr+JfDVWi3bVKN
         pUeT3xGw/7Yhgb+8e8/SOlIdc3N3T3XdwEsOgVWRU4UyyPcjuQbkF8tQv8U6FWVUnsqK
         gNEjZTuTi9dqE/IPVA1yOhqRbUTetPZ7uDwHc=
MIME-Version: 1.0
In-Reply-To: <4BFCC813.50806@gmail.com>
References: <4BFCC813.50806@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 26 May 2010 09:33:21 -0700
Message-ID: <AANLkTinLK5S9NcRE0fxwAqEKXndHrPj13MR-UWarKzPL@mail.gmail.com>
Subject: Re: [ath9k-devel] ath: Failed to stop TX DMA in 100 msec after 
	killing last frame
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: ath9k-devel@venema.h4ckr.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 12:04 AM, Justin P. Mattock
<justinmattock@gmail.com> wrote:
> This is new:
> [ 8660.899624] ath: Failed to stop TX DMA in 100 msec after killing last
> frame
> [ 8660.899676] ath: Unable to stop TxDMA. Reset HAL!
>
> I don't have hal installed!! should I be concerned?

No, the print can be changed to say "reseting hardware", patch welcomed.

  Luis
