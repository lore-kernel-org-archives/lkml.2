Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979Ab1KKTE4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 14:04:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50700 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757055Ab1KKTEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 14:04:54 -0500
Message-ID: <4EBD71BD.5090208@zytor.com>
Date: Fri, 11 Nov 2011 11:04:29 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Namjae Jeon <linkinjeon@gmail.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Matt_Domsch@dell.com, eugeneteo@kernel.sg, davej@codemonkey.org.uk,
        Warns@pre-sense.de
Subject: Re: [PATCH] efi: add option for MSR partition.
References: <1321030375-8221-1-git-send-email-linkinjeon@gmail.com>
In-Reply-To: <1321030375-8221-1-git-send-email-linkinjeon@gmail.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2011 08:52 AM, Namjae Jeon wrote:
> After formatting GUID table on MS windows, MSR(Windows Reserved Partition) is not visible on MS windows. But this partition is visible in linux. User don't want to see the stranged partitin. So I try to add option that user can select MSR partition to be visible or not in linux.

You're joking, right?

	-hpa

