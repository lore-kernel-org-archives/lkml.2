Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932967Ab0E0WMP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 18:12:15 -0400
Received: from mail.svr02.mucip.net ([83.170.6.69]:56857 "EHLO
	mailout.mucip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285Ab0E0WMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 18:12:13 -0400
X-Submitted: to mailout.mucip.net (Postfix) with ESMTPSA id 292864969
Message-ID: <4BFEEE3A.1010403@birkenwald.de>
Date: Fri, 28 May 2010 00:12:10 +0200
From: Bernhard Schmidt <berni@birkenwald.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Lightning/1.0b1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Zachary Amsden <zamsden@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Clock jumps
References: <loom.20100524T171038-56@post.gmane.org> <20100525062100.GP22163@redhat.com> <4BFD5616.6070302@cora.nwra.com> <4D7E210A-4694-4B6E-B721-6024CE96ABC0@suse.de> <htmdsk$9kn$1@dough.gmane.org> <4BFEE9F3.8040200@redhat.com>
In-Reply-To: <4BFEE9F3.8040200@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.05.2010 23:53, Zachary Amsden wrote:

Hello Zachary,

> I have server side fixes for this kvm-clock which seem to give me a
> stable clock on this machine, but for true SMP stability, you will need
> Glauber's guest side changes to kvmclock as well. It is impossible to
> guarantee strictly monotonic clocksource across multiple CPUs when
> frequency is dynamically changing (and also because of the C1E idle
> problems).

Is all this relevant only when the host is on TSC? Because I have seen 
these jumps when the host was on HPET and the guests were using kvm-clock.

Anyway, can you send me both patches? I'd like to try it, but I have 
completely lost track where the up-to-date patches are.

Bernhard
