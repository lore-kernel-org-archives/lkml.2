Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111Ab1AQKCA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 05:02:00 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61780 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab1AQKB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 05:01:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=l0o6xyh48EuwhtvKlXj7ZoYGfulaulmHzRm6UnyoPsrFIrPiPXfypvuFkkPCKOiNll
         IJQ6t9Iod4YK6+t0cLnSCbG6Mc1vRauFlN9gIqZTGVp/gEhpNhmO8FIpHxHubW0hyLee
         AAQJRNML6hmRlgAVGBEtWLTdI8VC/0zZZStC0=
MIME-Version: 1.0
In-Reply-To: <1295253729-23153-3-git-send-email-stanley.miao@windriver.com>
References: <1295253729-23153-1-git-send-email-stanley.miao@windriver.com>
	<1295253729-23153-3-git-send-email-stanley.miao@windriver.com>
Date: Mon, 17 Jan 2011 10:01:58 +0000
X-Google-Sender-Auth: E2nsgN9aGcCF8RMecdxEcVxuqVs
Message-ID: <AANLkTimXAtpRz=ZjmN8brHMQNqgGMKhpo=v_sFk_Aeuf@mail.gmail.com>
Subject: Re: [PATCH 2/3] support ARM BE8 mode on a little endian machine
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Stanley.Miao" <stanley.miao@windriver.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 January 2011 08:42, Stanley.Miao <stanley.miao@windriver.com> wrote:
> When BE8 kernel is running on a little endian machine, the kernel endian
> mode need to be converted at the begining of the startup procedure with
> the instruction "setend be".

Can we not let the boot loader do this? It could also prepare the tags
as big endian.

-- 
Catalin
