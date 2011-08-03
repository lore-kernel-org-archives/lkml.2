Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137Ab1HCC4Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 22:56:24 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:61510 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962Ab1HCC4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 22:56:18 -0400
Message-ID: <4E38B8BD.10406@gmail.com>
Date: Wed, 03 Aug 2011 10:55:57 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: =?UTF-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>
CC: Li Zefan <lizf@cn.fujitsu.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] jbd/jbd2: add pointer type conversion on void *arg from
 void * to journal_t * explicitly in kjournald/kjournald2
References: <4E38AB50.9040804@gmail.com>	<4E38AC92.4090501@cn.fujitsu.com>	<4E38AFC2.3070608@gmail.com> <CAM_iQpXJSDvHXtGFET7SgQTXUpk-v+hD24RzSR-sanf=4oY1xA@mail.gmail.com>
In-Reply-To: <CAM_iQpXJSDvHXtGFET7SgQTXUpk-v+hD24RzSR-sanf=4oY1xA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011年08月03日 10:52, Américo Wang wrote:
> On Wed, Aug 3, 2011 at 10:17 AM, Wang Sheng-Hui <shhuiw@gmail.com> wrote:
>>
>> I remember any * can be assigned directly to void * in ANSI C, but
>> void * should be converted to specific point * type. Right?
>>
> 
> C99 6.3.2.3

Got it. Thanks,

> 
> A pointer to void may be converted to or from a pointer to any
> incomplete or object
> type. A pointer to any incomplete or object type may be converted to a
> pointer to void
> and back again; the result shall compare equal to the original pointer.

