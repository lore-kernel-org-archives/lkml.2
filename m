Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761545Ab0J2SAE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 14:00:04 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48723 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424Ab0J2SAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 14:00:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=QAxWiPSzHmvADdiIYDMyrFRQKX97yPfpzwf5RHvzzx/QbgbPYSlfpQrFGm4gVUAIET
         tWt7M68zvaGyrntIrHwS/9i9bXG+EZRQ31jTblO5BYPeYNuk4YjZvhOJiumlrvVgK2+Z
         7jLE1ByFrxLV0Q1ZU36c779/+YPyfbdJ0FS5Q=
Subject: Re: [PATCH] u64_stats_sync.h: move "inline" before the return type
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Max Kellermann <mk@cm4all.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20101029150833.20666.70754.stgit@rabbit.intern.cm-ag>
References: <20101029150833.20666.70754.stgit@rabbit.intern.cm-ag>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Oct 2010 19:59:54 +0200
Message-ID: <1288375194.2560.312.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 29 octobre 2010 à 17:08 +0200, Max Kellermann a écrit :
> With the option -Wextra, gcc emits warnings like this one:
> 
>  include/linux/u64_stats_sync.h:70: warning: 'inline' is not at beginning of declaration
> 
> While this is legal according to the C standard, it would be more
> readable to have all modifiers before the return type.
> ---

Acked-by: Eric Dumazet <eric.dumazet@gmail.com>



