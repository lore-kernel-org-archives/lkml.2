Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab2HOMIh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 08:08:37 -0400
Received: from mail.yuiop.co.uk ([89.145.97.74]:49896 "EHLO mail.yuiop.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752115Ab2HOMIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 08:08:36 -0400
X-Greylist: delayed 1070 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Aug 2012 08:08:35 EDT
Message-ID: <502B8D1F.7030706@anonymous.org.uk>
Date: Wed, 15 Aug 2012 12:50:55 +0100
From: John Robinson <john.robinson@anonymous.org.uk>
Organization: None; Disorganization: Total
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: O_DIRECT to md raid 6 is slow
References: <CALCETrWCu=UPATPdqWP=Gpvswv-RDwaxfr1W1jxYtUMZsqKgSQ@mail.gmail.com>
In-Reply-To: <CALCETrWCu=UPATPdqWP=Gpvswv-RDwaxfr1W1jxYtUMZsqKgSQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/08/2012 01:49, Andy Lutomirski wrote:
> If I do:
> # dd if=/dev/zero of=/dev/md0p1 bs=8M
[...]
> It looks like md isn't recognizing that I'm writing whole stripes when
> I'm in O_DIRECT mode.

I see your md device is partitioned. Is the partition itself stripe-aligned?

Cheers,

John.

