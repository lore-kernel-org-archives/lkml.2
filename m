Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757123Ab0EXPTv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 11:19:51 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:53570 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208Ab0EXPTu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 11:19:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LqYmz8BjQrOCXcXu7/rbZzBMXG7i5du/CftQ5pX5aup1R2r78xLcxP5uRIBdqi57jH
         xjYV9NmRovE7QB+NZtKLUInSvG8puhUYxA8A0UWkxvivS3Dq8UKXsWG2cjkOFT6zYVAR
         NowgOkWvNBDrhm0Uwli88tb6Q34Cpx3JJ2wZA=
MIME-Version: 1.0
In-Reply-To: <20100524144539.GE21117@n2100.arm.linux.org.uk>
References: <1274615328-27953-1-git-send-email-tom.leiming@gmail.com>
	 <AANLkTikRp0EHxshKYq39p18ymoRNAtyHrNm3yq6A49-r@mail.gmail.com>
	 <20100523141300.GD950@n2100.arm.linux.org.uk>
	 <AANLkTinV9Na9zxYMIfTr893Ynnc0YOk2B6uPKEa9s4R1@mail.gmail.com>
	 <20100523194746.GE950@n2100.arm.linux.org.uk>
	 <20100524112355.18424622@tom-lei>
	 <20100524071921.GA17528@n2100.arm.linux.org.uk>
	 <20100524101416.GA21117@n2100.arm.linux.org.uk>
	 <20100524222033.12b25f2a@tom-lei>
	 <20100524144539.GE21117@n2100.arm.linux.org.uk>
Date: Mon, 24 May 2010 23:19:48 +0800
Message-ID: <AANLkTikGwEVtnGb5KdJb0GzWDpu-zk9bWwa3JAgwy1v3@mail.gmail.com>
Subject: Re: [RESEND PATCH] ARM: fix 'unannotated irqs-on' lockdep warning
From: Ming Lei <tom.leiming@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, a.p.zijlstra@chello.nl
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/5/24 Russell King - ARM Linux <linux@arm.linux.org.uk>:
> which needs to be redone with a little more understanding, like the
> following patch.  Note: you will need the previous patch as well,
> which is separate because it addresses a *different* issue.

OK, the two patches do fix the 'unannotated irqs-on' lockdep warning.

Thanks,

-- 
Lei Ming
