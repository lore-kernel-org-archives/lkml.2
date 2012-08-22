Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933393Ab2HVVRQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 17:17:16 -0400
Received: from nctlincom02.orcon.net.nz ([60.234.4.75]:40625 "EHLO
	nctlincom02.orcon.net.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933336Ab2HVVRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 17:17:13 -0400
Cc: linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org
Message-Id: <C17EFEEA-F810-4BC7-A6A0-9F992535F741@orcon.net.nz>
From: Michael Cree <mcree@orcon.net.nz>
To: Bob Tracy <rct@gherkin.frus.com>
In-Reply-To: <20120822121407.GA6257@gherkin.frus.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: [BUG] net/core/sock.c won't compile on alpha
Date: Thu, 23 Aug 2012 09:16:53 +1200
References: <20120822121407.GA6257@gherkin.frus.com>
X-Mailer: Apple Mail (2.936)
X-DSPAM-Check: by mx6.orcon.net.nz on Thu, 23 Aug 2012 09:17:10 +1200
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Thu Aug 23 09:17:10 2012
X-DSPAM-Confidence: 0.7611
X-DSPAM-Probability: 0.0000
X-Bayes-Prob: 0.0001 (Score 0, tokens from: @@RPTN, default)
X-Spam-Score: 0.00 () [Hold at 5.50] 
X-CanIt-Geo: ip=130.217.188.11; country=NZ; region=G1; city=Hamilton; latitude=-37.7833; longitude=175.2833; http://maps.google.com/maps?q=-37.7833,175.2833&z=6
X-CanItPRO-Stream: base:default
X-Canit-Stats-ID: 05HNVrerM - aa8fc91c7131 - 20120823
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/08/2012, at 12:14 AM, Bob Tracy wrote:
> Kernel version 3.6.0-rc2, and probably -rc1 as well.  I get the
> following compile-time error on alpha architecture:
>
> (...)
>  CC      net/core/sock.o
> net/core/sock.c:274:36: error: initializer element is not constant

Try v3.6-rc3.  It should be fixed now.

Cheers
Michael.


