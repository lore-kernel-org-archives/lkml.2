Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031093Ab2HIP2W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 11:28:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18958 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758438Ab2HIP2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 11:28:19 -0400
X-Authority-Analysis: v=2.0 cv=ZuBv2qHG c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=LzBzSxG1IzkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=TevqYXmoyiODW8MIYWkA:9 a=PUjeQqilurYA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-ID: <1344526098.6935.44.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] net: add new QCA alx ethernet driver
From: Steven Rostedt <rostedt@goodmis.org>
To: Joe Perches <joe@perches.com>
Cc: "Ren, Cloud" <cjren@qca.qualcomm.com>, David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        qca-linux-team <qca-linux-team@qualcomm.com>,
        nic-devel <nic-devel@qualcomm.com>,
        "Huang, Xiong" <xiong@qca.qualcomm.com>,
        "hao-ran.liu@canonical.com" <hao-ran.liu@canonical.com>,
        "Rodriguez, Luis" <rodrigue@qca.qualcomm.com>
Date: Thu, 09 Aug 2012 11:28:18 -0400
In-Reply-To: <1344525758.3165.8.camel@joe2Laptop>
References: <6349D7A510622448B1BA0967850A8438013692CA@NASANEXD02D.na.qualcomm.com>
	 <1344485382.2024.9.camel@joe2Laptop>
	 <6349D7A510622448B1BA0967850A843801369364@NASANEXD02D.na.qualcomm.com>
	 <20120808.231804.12694947300243733.davem@davemloft.net>
	 <6349D7A510622448B1BA0967850A8438013693DD@NASANEXD02D.na.qualcomm.com>
	 <20120809145454.GA21195@home.goodmis.org>
	 <1344525758.3165.8.camel@joe2Laptop>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-09 at 08:22 -0700, Joe Perches wrote:

> Yes, I sent signed-off patches to their original RFC submission
> (back last year?).  To me, this single large patch is like a
> snapshot of a git tree and not all contributors to that git
> tree should be noted as signers of the entire thing.

Ouch, that looks like we are losing all history.

One large patch should not be submitted. If it was developed in steps,
then it is best to show those steps when they are incorporated into the
Linux repository.

Sure, the patches may be reworked and folded together where appropriate,
but when I read "this single large patch is like a snapshot of a git
tree", that right there is a red flag.


-- Steve



