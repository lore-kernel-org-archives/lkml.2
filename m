Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168Ab2BMTc5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 14:32:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59946 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754309Ab2BMTc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 14:32:56 -0500
Message-ID: <4F39655B.4000904@zytor.com>
Date: Mon, 13 Feb 2012 11:32:43 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Kirill Smelkov <kirr@mns.spb.ru>, Paul Parsons <lost.distance@yahoo.com>,
        linux-kernel@vger.kernel.org
Subject: Re: No /dev/root with devtmpfs?
References: <20120210090425.GA3997@tugrik.mns.mnsspb.ru> <1328879437.80871.YahooMailClassic@web29006.mail.ird.yahoo.com> <20120213082539.GA5930@tugrik.mns.mnsspb.ru> <4F395AFE.9010802@zytor.com> <CAPXgP12W8mTOX5-86sBCJtLACMJWo3ovAiH91VF4JoBq9kxnQA@mail.gmail.com>
In-Reply-To: <CAPXgP12W8mTOX5-86sBCJtLACMJWo3ovAiH91VF4JoBq9kxnQA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2012 11:30 AM, Kay Sievers wrote:
>
> root=PARTUUID= is in-kernel mount GTP support, which works without an initramfs.
>

Oh joy, let's grow more stuff into the kernel...

	-hpa

