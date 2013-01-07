Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934Ab3AGOkF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 09:40:05 -0500
Received: from cassarossa.samfundet.no ([129.241.93.19]:35298 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387Ab3AGOkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 09:40:04 -0500
Date: Mon, 7 Jan 2013 15:40:00 +0100
From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PEBS (in perf) stopped working from 3.6 -> 3.7
Message-ID: <20130107144000.GA8145@uio.no>
References: <20130104234743.GA12331@uio.no>
 <50E770DB.2050803@gmail.com>
 <20130105010501.GA5371@uio.no>
 <50EA4594.9020309@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50EA4594.9020309@gmail.com>
X-Operating-System: Linux 3.7.1 on a x86_64
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-Score: 1.3 (+)
X-Spam-Report: Status=No hits=1.3 required=5.0 tests=FREEMAIL_FROM,RDNS_NONE version=3.3.1 hostname=cassarossa.samfundet.no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 06, 2013 at 08:48:36PM -0700, David Ahern wrote:
>> Why would the two be different?
> I will make a guess that is processor dependent. On an E5540 with
> 3.4.11-1.fc16.x86_64, 3.6.10-2.fc16.x86_64, and 3.8 I get the same
> failure message.
> 
> But on a E5620, it works fine with 3.4 and 3.7 (no intermediate
> kernels on that box).

That sounds a bit odd; the CPU can certainly do it with 3.6.

/* Steinar */
-- 
Homepage: http://www.sesse.net/
