Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878Ab2AJLug (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 06:50:36 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:36264 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843Ab2AJLue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 06:50:34 -0500
MIME-Version: 1.0
In-Reply-To: <4F0B6845.4080503@xenotime.net>
References: <20120109113633.24486.69758.stgit@localhost6.localdomain6>
	<20120109113641.24486.95511.stgit@localhost6.localdomain6>
	<4F0B6845.4080503@xenotime.net>
Date: Tue, 10 Jan 2012 13:50:32 +0200
Message-ID: <CAPiS6wCVo40tB40sXTzTt7RpVHJG_2wrYeP8L=ghin09WHftfg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] menuconfig: add Home and End keys support for inputbox
From: Paulius Zaleckas <paulius.zaleckas@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: mmarek@suse.cz, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 10, 2012 at 12:20 AM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On 01/09/2012 03:36 AM, Paulius Zaleckas wrote:
>> Makes long string editing easier.
>>
>> Signed-off-by: Paulius Zaleckas <paulius.zaleckas@gmail.com>
>
> Hi,
>
> Does "default hostname" in the "General setup" menu use an inputbox?

Yes, it does.

> If so, I can't get Home and End keys to work for it.

Strange. It works for me. Have you applied both patches?

> If not, please tell me a field that uses an inputbox so that I can test it.
>
> Thanks.
