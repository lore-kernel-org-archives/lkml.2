Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982Ab1IBMwN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 08:52:13 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:42203 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845Ab1IBMwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 08:52:11 -0400
X-AuditID: b753bd60-a1479ba0000050a4-71-4e60d177ccae
X-AuditID: b753bd60-a1479ba0000050a4-71-4e60d177ccae
Message-ID: <4E60D16A.8060802@hitachi.com>
Date: Fri, 02 Sep 2011 21:51:54 +0900
From: Nao Nishijima <nao.nishijima.xt@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        James.Bottomley@HansenPartnership.com,
        dle-develop@lists.sourceforge.net,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com, kay.sievers@gmail.com
Subject: Re: [-v3 PATCH 0/3] Persistent device name using alias
References: <20110825090359.2288.91057.stgit@ltc197.sdl.hitachi.co.jp> <20110825101602.GI3286@htj.dyndns.org> <4E58C3BD.3000609@hitachi.com> <20110827102655.GJ2632@htj.dyndns.org>            <4E58E905.4020704@hitachi.com> <16628.1314734537@turing-police.cc.vt.edu>
In-Reply-To: <16628.1314734537@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Valdis,

(2011/08/31 5:02), Valdis.Kletnieks@vt.edu wrote:
> On Sat, 27 Aug 2011 21:54:29 +0900, Nao Nishijima said:
> 
>> A kernel device names (e.g. sda) is not useful information because it
>> doesn't always point the same disk at each boot-up time.
> 
> If this is important to you, can't you use a udev rule, similar to what most
> distros already stick in 70-persistent-net.rules and 70-persistent-cd.rules?
> 
> (Yes, this *does* involve finding a UUID or label or  something on the disk
> that you can identify as "same entity as last time".

As you said, it is able to identify a disk at the expense of checking
cost. However to introduce "alias" is an advantage of reducing both the
cost and the risk of miss-communication, and it can easily identify it.

And also, currently, kernel log and command output do not accord with
the device name which a user uses (e.g. by-id, by-uuid). I would try to
solve those mismatches using "alias". In other words, I'd like to
introduce aliases for integrating the name of devices to control and record.

Of course I will modify commands using a device name to use a persistent
device names.


Best regards,

-- 
Nao NISHIJIMA
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., YOKOHAMA Research  Laboratory
Email： nao.nishijima.xt@hitachi.com
