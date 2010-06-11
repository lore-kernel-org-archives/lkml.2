Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760636Ab0FKVjg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 17:39:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47956 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754614Ab0FKVje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 17:39:34 -0400
Message-ID: <4C12ACF3.8000007@zytor.com>
Date: Fri, 11 Jun 2010 14:38:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       linux-kernel@vger.kernel.org
Subject: Re: sequence lock in Linux
References: <20100611194016.GA5213@Krystal> <AANLkTil84IIgzlPcycNWJFRpZIGRqTFL6FGffzqOaSEx@mail.gmail.com> <20100611203607.GH2394@linux.vnet.ibm.com> <4C12A539.1000709@zytor.com> <20100611213602.GI2394@linux.vnet.ibm.com>
In-Reply-To: <20100611213602.GI2394@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2010 02:36 PM, Paul E. McKenney wrote:
> Memory barriers in the sequence-lock code prevent this, assuming, as
> you point out, that memory clobber works (but if it doesn't, it should
> be fixed):

The constness is my main concern.  It's not clear to me that "memory" is
meant to imply that const memory areas without volatile can be clobbered.

	-hpa
