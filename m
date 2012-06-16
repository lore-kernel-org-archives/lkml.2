Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004Ab2FPJVb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 05:21:31 -0400
Received: from smtprelay02.ispgateway.de ([80.67.31.40]:58279 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057Ab2FPJVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 05:21:30 -0400
Message-ID: <4FDC4FF8.1030804@ladisch.de>
Date: Sat, 16 Jun 2012 11:20:56 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Mahmood Naderan <nt_mahmood@yahoo.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: about interlagos
References: <1339828893.59679.YahooMailNeo@web111722.mail.gq1.yahoo.com>
In-Reply-To: <1339828893.59679.YahooMailNeo@web111722.mail.gq1.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Df-Sender: bGludXgta2VybmVsQGNsLmRvbWFpbmZhY3Rvcnkta3VuZGUuZGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mahmood Naderan wrote:
> As you can see, although interlagos is the newest one which has higher cpu
> clock rate and higher cache size, the bogomips of interlagos is the lowest!
> I read that bogomips is not a true measurement,

Indeed it is not.

> but it senses as a speed meter.

It measures the speed of one particular delay loop.  Because such a busy
loop is pretty much the silliest thing you could do to a CPU, it does
not make sense to use it to measure overall CPU speed, or to compare
different microarchitectures.

> Any idea?

If you want to know how fast your code will execute, you have to measure
that code.  If you are too lazy to do this, search for a benchmark that
represents that code well; for general-purpose code, the gcc part of the
SPEC CPU benchmark probably comes closest.


Regards,
Clemens
