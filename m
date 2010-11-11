Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913Ab0KKMCt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 07:02:49 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55832 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593Ab0KKMCs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 07:02:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Ph75QOZaHQkxabjwmZeZwA40vrvZHr8cOIOvedNc4ESSi/I2pgmUg/1QOSYnoDCRZB
         B/My/3cTzgvQ687CHzjZOJS62Xh7ehPpg/hbss4cyubXDhgWoJ0FFZ0OHoEa4ceo4zZB
         m4/IH5Z0Hks3BwYbCnSGa3iTncGOsCZrenIGE=
MIME-Version: 1.0
In-Reply-To: <1289473363-29440-4-git-send-email-tj@kernel.org>
References: <1289473363-29440-1-git-send-email-tj@kernel.org>
	<1289473363-29440-4-git-send-email-tj@kernel.org>
Date: Thu, 11 Nov 2010 14:02:46 +0200
X-Google-Sender-Auth: _7TAXe7mtTNoSSh6trkkH-htTfs
Message-ID: <AANLkTini0PMD-Xh7TsUHFKrWRp6NP2Kfsg560fuw-xO3@mail.gmail.com>
Subject: Re: [PATCH 3/9] x86: Make default_send_IPI_mask_sequence/allbutself_logical()
 32bit only
From: Pekka Enberg <penberg@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, eric.dumazet@gmail.com,
        yinghai@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 1:02 PM, Tejun Heo <tj@kernel.org> wrote:
> Both functions are used only in 32bit.  Put them inside CONFIG_X86_32.
> This is to prepare for logical apicid handling update.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>

Acked-by: Pekka Enberg <penberg@kernel.org>
