Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532Ab2EAArk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 20:47:40 -0400
Received: from gate.crashing.org ([63.228.1.57]:54233 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757325Ab2EAArj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 20:47:39 -0400
Message-ID: <1335833251.20866.96.camel@pasglop>
Subject: Re: [REGRESSION][PATCH V4 3/3] bpf jit: Let the powerpc jit handle
 negative offsets
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jan Seiffert <kaffeemonster@googlemail.com>
Cc: David Miller <davem@davemloft.net>, eric.dumazet@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 01 May 2012 10:47:31 +1000
In-Reply-To: <4F9F31E0.5020308@googlemail.com>
References: <1335760199.20866.33.camel@pasglop>
	 <4F9E188E.80503@googlemail.com> <1335763568.20866.37.camel@pasglop>
	 <20120430.134140.1738751315208907289.davem@davemloft.net>
	 <1335822926.20866.47.camel@pasglop> <1335823049.20866.48.camel@pasglop>
	 <4F9F12ED.1090009@googlemail.com> <1335831987.20866.93.camel@pasglop>
	 <4F9F31E0.5020308@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-01 at 02:44 +0200, Jan Seiffert wrote:
> But a sane way forward?
> 
> BTW, has anyone checked the new syscall filter code for these ...
> misfortunes?
> I mean before the ABI is set in stone...
> 
Nope, not yet, looks like something I should do :-)

Cheers,
Ben.


