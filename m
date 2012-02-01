Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834Ab2BADki (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 22:40:38 -0500
Received: from BERING.ISR.CS.CMU.EDU ([128.2.209.223]:39758 "EHLO
	bering.isr.cs.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755758Ab2BADkg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 22:40:36 -0500
X-Greylist: delayed 1783 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Jan 2012 22:40:36 EST
References: <cover.1328049542.git.joe@perches.com> <db4ffce1e5a8a3a6e54e7a4f6487e822709dbdba.1328049542.git.joe@perches.com> <4F288178.4040405@gmail.com> <1328055665.14714.5.camel@joe2Laptop> <4F2885EC.8070900@gmail.com> <1328055976.14714.7.camel@joe2Laptop>
User-Agent: K-9 Mail for Android
In-Reply-To: <1328055976.14714.7.camel@joe2Laptop>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH 1/4] coda: Remove unnecessary OOM messages
From: Jan Harkes <jaharkes@cs.cmu.edu>
Date: Tue, 31 Jan 2012 22:10:45 -0500
To: Joe Perches <joe@perches.com>, Ryan Mallon <rmallon@gmail.com>
CC: linux-kernel@vger.kernel.org
Message-ID: <189650fe-7304-4762-a353-e355609f3e84@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> wrote:

>On Wed, 2012-02-01 at 11:23 +1100, Ryan Mallon wrote:
>> On 01/02/12 11:21, Joe Perches wrote:
>> > Maybe because alloc/free functions are
>> > used relatively infrequently, maybe it'd
>> > be better to not declare the functions
>> > inline but add them to coda_linux.c
>> Sure, either approach is fine. Do you want to add the patch to your
>series?
>
>I think Jan can work it out properly if he wants it.

It looks good to me, I have no problem if you want to add it to your series.

Jan

