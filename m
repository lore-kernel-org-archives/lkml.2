Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586Ab0KKLPD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 06:15:03 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:59563 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755351Ab0KKLPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 06:15:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=wUIQpv0GhYI8LEix2NW6LrXgDefA/vaCwNLQR5I0s4iUtvXo+zU7AJF/ZMELPQ6T70
         dFRqoQoDoYxcFY2SlgbdCjbSJYOFtoENPq9Gij3DkZrBYmsMBWQdPLQQU4kThU33cQRe
         YQIVs8JoPYQZrBYb6ErP+J5/Cog0P70DjifI8=
MIME-Version: 1.0
In-Reply-To: <1289473363-29440-3-git-send-email-tj@kernel.org>
References: <1289473363-29440-1-git-send-email-tj@kernel.org>
	<1289473363-29440-3-git-send-email-tj@kernel.org>
Date: Thu, 11 Nov 2010 13:15:00 +0200
X-Google-Sender-Auth: wAPVkXaAelFIcAAN2p9k9zl3tTw
Message-ID: <AANLkTimLdB5X1c8UvZedsf4ZqmOGT5xqM4BXYwH+j1WH@mail.gmail.com>
Subject: Re: [PATCH 2/9] x86: Rename x86_32 MAX_APICID to MAX_LOCAL_APIC
From: Pekka Enberg <penberg@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, eric.dumazet@gmail.com,
        yinghai@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 1:02 PM, Tejun Heo <tj@kernel.org> wrote:
> Replace x86_32 MAX_APICID in include/asm/mpspec.h with MAX_LOCAL_APIC
> in include/asm/apicdef.h to make it consistent with x86_64.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
