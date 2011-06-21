Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400Ab1FUJyA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 05:54:00 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:48263 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755460Ab1FUJx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 05:53:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=U/4FaaaPi4J2gNeVqHusLgeFquqXUMoydd1TgBC6SDyy2Fn5n5Eiz2vBVpTBK60Hk2
         VgCi4lawg3exd/EMlXuwwfcYWqnJG7qf1p5H/n79K6Dk+mzKVaTMu99FicF0eP2HErCq
         ZWxuNpoR8fOF3BlLBCNdSIcKXf8SBlg8ldV1I=
MIME-Version: 1.0
In-Reply-To: <1308647858-1821-1-git-send-email-yuanlmm@gmail.com>
References: <BANLkTik-L1MNQspeaMhfxe4Uy1YGV+t6FA@mail.gmail.com>
	<1308647858-1821-1-git-send-email-yuanlmm@gmail.com>
Date: Tue, 21 Jun 2011 11:53:57 +0200
X-Google-Sender-Auth: jCAKmPm8Yb3gRfuP58n-qZywjFI
Message-ID: <BANLkTin0V=jRz7mr1cWYgb3aoShfO30EtA@mail.gmail.com>
Subject: Re: [PATCH v5] ahci: move ahci_sb600_softreset to libahci.c and
 rename it
From: Tejun Heo <tj@kernel.org>
To: Yuan-Hsin Chen <yuanlmm@gmail.com>
Cc: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        sshtylyov@mvista.com, Yuan-Hsin Chen <yhchen@faraday-tech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Jun 21, 2011 at 11:17 AM, Yuan-Hsin Chen <yuanlmm@gmail.com> wrote:
> From: Yuan-Hsin Chen <yhchen@faraday-tech.com>
>
> ahci_sb600_softreset was in ahci.c. This function is used
> to fix soft reset failure and renames as ahci_pmp_retry_softreset
> in libahci.c.
>
> Signed-off-by: Yuan-Hsin Chen <yhchen@faraday-tech.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks for your persistence. :)

-- 
tejun
