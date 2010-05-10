Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497Ab0EJXKH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:10:07 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:47264 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932977Ab0EJW67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:58:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=C5Xi1qmoS5AN42k9WVfuTqxleDU1QykPkqVz34Uy9kllBYqUBzUEOAtpV5ZOh/ld/b
         OY8sxq3+1ndHqQrXASb5HrxC9HyxRYkeNTc/u4cFItVzMH3a1ZFvc0ucLr8MZZSElqXB
         lr1Xd3ZvVevpZ/b6Z2M8Mfq3Lfu611GCBYweQ=
MIME-Version: 1.0
In-Reply-To: <4BE6D437.9000200@gmail.com>
References: <4BE6D437.9000200@gmail.com>
Date: Mon, 10 May 2010 15:58:58 -0700
X-Google-Sender-Auth: JyOyi5Sp4xPqty9n1ONLwJQbz3w
Message-ID: <AANLkTil_SWX1iPKRmD_YQgtgQcCzV27MEQwP6tPPQRXL@mail.gmail.com>
Subject: Re: Keep index within boundaries in kvmppc_44x_emul_tlbwe()
From: Hollis Blanchard <hollis@penguinppc.org>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Alexander Graf <agraf@suse.de>, kvm-ppc@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 9, 2010 at 8:26 AM, Roel Kluin <roel.kluin@gmail.com> wrote:
> An index of KVM44x_GUEST_TLB_SIZE is already one too large.
>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Acked-by: Hollis Blanchard <hollis@penguinppc.org>

Thanks Roel.

-Hollis
