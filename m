Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab2E1QTu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 12:19:50 -0400
Received: from katalix.com ([82.103.140.233]:34046 "EHLO mail.katalix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753855Ab2E1QTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 12:19:42 -0400
Message-ID: <4FC3A599.1040909@katalix.com>
Date: Mon, 28 May 2012 17:19:37 +0100
From: James Chapman <jchapman@katalix.com>
Organization: Katalix Systems Ltd
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: Eric Dumazet <eric.dumazet@gmail.com>, David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Wrong usage of hash in L2TP leading to NULL ptr derefs
References: <1338221539.4284.25.camel@lappy>
In-Reply-To: <1338221539.4284.25.camel@lappy>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/05/12 17:12, Sasha Levin wrote:
> Hi all,
> 
> Looking at net/l2tp/l2tp_ip{6}.c, l2tp uses UDP for communications, but
> uses inet_hash and inet_unhash for hashing - which appears to be wrong
> (and causes NULL ptr derefs during runtime).

L2TPv3 also supports IP encapsulation, which is L2TP directly in IP, no
UDP. That's what the l2tp_ip[6] code implements.

Can you post an oops with steps for how to reproduce it?


-- 
James Chapman
Katalix Systems Ltd
http://www.katalix.com
Catalysts for your Embedded Linux software development
