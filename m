Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab0KFLk7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 07:40:59 -0400
Received: from pindarots.xs4all.nl ([80.101.128.228]:49208 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960Ab0KFLk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 07:40:59 -0400
Message-ID: <4CD53EC7.3070306@xs4all.nl>
Date: Sat, 06 Nov 2010 12:40:55 +0100
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Anca Emanuel <anca.emanuel@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: task vboxgetty:16758 blocked for more than 120 seconds. 2.6.35.7
References: <4CD53AE6.5090204@xs4all.nl> <AANLkTik7_9Ovfv5kkMBRdeZrJf5Q01usKU9d4xcCLiuz@mail.gmail.com>
In-Reply-To: <AANLkTik7_9Ovfv5kkMBRdeZrJf5Q01usKU9d4xcCLiuz@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-11-06 12:31, Anca Emanuel wrote:
> Did you tried this ?
> http://lkml.org/lkml/2010/11/4/247

Doesn't fully apply over 2.6.35.7:
linux-2.6.orig/kernel/sched_stoptask.c is not present.

Udo
