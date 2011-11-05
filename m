Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751296Ab1KENct (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 09:32:49 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51396 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab1KENcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 09:32:48 -0400
Message-ID: <4EB53AEF.903@googlemail.com>
Date: Sat, 05 Nov 2011 14:32:31 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.2.23) Gecko/20110920 SUSE/3.1.15 Lightning/1.0b2 Thunderbird/3.1.15
MIME-Version: 1.0
To: Yong Zhang <yong.zhang0@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: kernel panic on device removal when using a workqueue and delayed_work
References: <4EADA32E.6030200@googlemail.com> <20111031031136.GA18057@zhy> <4EAE77F2.80102@googlemail.com> <20111102063119.GA7387@zhy>
In-Reply-To: <20111102063119.GA7387@zhy>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 02.11.2011 07:31, schrieb Yong Zhang:
> On Mon, Oct 31, 2011 at 11:26:58AM +0100, Frank Schäfer wrote:
>> Am 31.10.2011 04:11, schrieb Yong Zhang:
>> That's what I'm doing (see above).
>> Did you read the code ? ;-)
> Oh, blind me.
>
> Maybe you can enable DEBUG_OBJECTS_TIMERS&&  DEBUG_OBJECTS_WORK
> to check if anything is broken.
I enabled both debug options but nothing changed (nothing new in the logs).
Any other ideas to debug this further ?

Thanks,
Frank
> Thanks,
> Yong

