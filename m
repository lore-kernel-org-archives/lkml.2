Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743Ab0LIJhF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 04:37:05 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54916 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab0LIJhC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 04:37:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=OMALUoBSHaElcnTC2v0vin1syf8vznSjpzjF7jonVQatSmcaKqpFQib0RGGCvZ/iMV
         ekvcgkUZCOR01WcM1sCIq7ydlgoClmWn5YcoMMN16QERGoqVvN1AuIHUB9efWoHpzJUy
         thscaU8k0v3zez4HafqmcpLhBTn5WQiO+Hm1I=
MIME-Version: 1.0
In-Reply-To: <4CF53E61.1030307@kernel.org>
References: <1290871325-3055-1-git-send-email-tj@kernel.org>
	<1290871325-3055-5-git-send-email-tj@kernel.org>
	<4CF53E61.1030307@kernel.org>
Date: Thu, 9 Dec 2010 11:37:01 +0200
X-Google-Sender-Auth: j_3556i5opoR3NFh7xEZF0XMMS8
Message-ID: <AANLkTinGzmOzSD6DtF9XwJRA7HMrKxo-dm1WAHUeGBXS@mail.gmail.com>
Subject: Re: [PATCH UPDATED#2 04/16] x86: Use local variable to cache
 smp_processor_id() in setup_local_APIC()
From: Pekka Enberg <penberg@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, eric.dumazet@gmail.com,
        yinghai@kernel.org, brgerst@gmail.com, gorcunov@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 8:11 PM, Tejun Heo <tj@kernel.org> wrote:
> This is a trivial clean up.
>
> * Move initialization of @cpu inside preemption disabled region as
>  suggested by Cyrill Gorcunov.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: Cyrill Gorcunov <gorcunov@gmail.com>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
