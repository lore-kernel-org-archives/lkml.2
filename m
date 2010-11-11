Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527Ab0KKLNL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 06:13:11 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:34630 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755270Ab0KKLNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 06:13:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=FOjHty+k2mSrKWoVVA3uIv6as9mn9SyCf2GjfUfk098+NqLZtncGEZb/YQRz84eZav
         F+MLEBXX6Twfn8w+6G4dwRCcfv8CjpIlcAdIWZHQbx1lwfs5PotHmwqrSpQSsLJU9FJX
         xvjeO0+ashlbXmWH8vm1gYchGKAB2sxIPLSQ0=
MIME-Version: 1.0
In-Reply-To: <1289473363-29440-2-git-send-email-tj@kernel.org>
References: <1289473363-29440-1-git-send-email-tj@kernel.org>
	<1289473363-29440-2-git-send-email-tj@kernel.org>
Date: Thu, 11 Nov 2010 13:13:08 +0200
X-Google-Sender-Auth: SydYqsvWmSrdj5SXFkBFB-BrNaI
Message-ID: <AANLkTimC82omahCQUUm3ej=T2e1yPpNhuKgnrnKu8z5+@mail.gmail.com>
Subject: Re: [PATCH 1/9] x86: Kill unused static boot_cpu_logical_apicid in smpboot.c
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
> Signed-off-by: Tejun Heo <tj@kernel.org>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
