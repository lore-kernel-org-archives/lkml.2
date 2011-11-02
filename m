Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751228Ab1KBUCk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 16:02:40 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43817 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab1KBUCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 16:02:37 -0400
Message-ID: <4EB1A1CF.7090300@googlemail.com>
Date: Wed, 02 Nov 2011 21:02:23 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.2.23) Gecko/20110920 SUSE/3.1.15 Lightning/1.0b2 Thunderbird/3.1.15
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: kernel panic on device removal when using a workqueue and delayed_work
References: <4EADA32E.6030200@googlemail.com> <20111031031136.GA18057@zhy> <4EAE77F2.80102@googlemail.com> <201110311129.25277.oliver@neukum.org>
In-Reply-To: <201110311129.25277.oliver@neukum.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 31.10.2011 11:29, schrieb Oliver Neukum:
> Am Montag, 31. Oktober 2011, 11:26:58 schrieb Frank Schäfer:
>> Am 31.10.2011 04:11, schrieb Yong Zhang:
>>>> This is the first time I'm using a workqueue, so there is a good
>>>> chance that I missed something...
>>> You should cancel the work you have armed before exit.
>>> See cancel_delayed_work().
>> That's what I'm doing (see above).
>> Did you read the code ? ;-)
> Does it work if you set a flag and resubmit the work only conditionally
> on it?
What do you mean ? Which flag should I set and what's the condition to 
check for ?

Regards,
Frank
> 	Regards
> 		Oliver

