Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741Ab1FNFbd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 01:31:33 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61689 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081Ab1FNFba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 01:31:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=K6gW3P22Vao8eRtKWFxl6/Pvjy3X1ury8ejMxI1AJUXVRpDnhv3LUl4lh4S780PKyd
         L6TY65vOuUTKr6zy+f1OMfcAGtpQMwPBAPAcU9jZv8CF6XGJMjcOwZBVHk1PVLxmeB/h
         Q1Dqlh5G0GciZzVWEBRnh+8KO60HuGF8t8Yhk=
MIME-Version: 1.0
In-Reply-To: <005501cc2a52$c05df650$4119e2f0$%kim@samsung.com>
References: <1308025989-877-1-git-send-email-pullip.cho@samsung.com>
	<005501cc2a52$c05df650$4119e2f0$%kim@samsung.com>
Date: Tue, 14 Jun 2011 14:31:29 +0900
X-Google-Sender-Auth: DQTNiWMFYdnhoSBcR0Fw6VAKwBE
Message-ID: <BANLkTinqzPfg_S3eJoM=aBacDK9T+3L-FQ@mail.gmail.com>
Subject: Re: [PATCH] dma-mapping: Undefine dma_map_single(), etc if
 CONFIG_HAVE_DMA_ATTRS is defined
From: KyongHo Cho <pullip.cho@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, arnd@arndb.de,
        fujita.tomonori@lab.ntt.co.jp, rmk@arm.linux.org.uk,
        joerg.roedel@amd.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 14, 2011 at 2:20 PM, Kukjin Kim <kgene.kim@samsung.com> wrote:
>> Change-Id: Ib99ee2b355dbe679263ce2e4e27d6219148c8338
>
> Please don't use this here.
>
I forgot to remove that.
Thank you.
