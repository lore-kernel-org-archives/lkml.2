Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050Ab2IIPVf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 11:21:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20372 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199Ab2IIPVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 11:21:34 -0400
X-Authority-Analysis: v=2.0 cv=VPlfbqzX c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=lePEUdhtsMoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=WAGQ5AIEONIA:10 a=Vj0vZH26mhjJQOcwaEwA:9 a=PUjeQqilurYA:10 a=FDrVQTxijjwA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1347204091.4746.14.camel@gandalf.local.home>
Subject: Re: [BUG][3.4.10] Conflicts between initializing my USB devices and
 my IDE devices
From: Steven Rostedt <rostedt@goodmis.org>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
        gregkh@linuxfoundation.org, sarah.a.sharp@linux.intel.com,
        stable@vger.kernel.org
Date: Sun, 09 Sep 2012 11:21:31 -0400
In-Reply-To: <20120908.182504.1746728709833661358.davem@davemloft.net>
References: <1347142965.4746.11.camel@gandalf.local.home>
	 <20120908.182504.1746728709833661358.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-09-08 at 18:25 -0400, David Miller wrote:
> The IDE layer does not handle shared interrupts properly at all,
> and it never will be rearchitected to do so.
> 
> This is a well known issue.
> 

Come to think of it, I believe I even reported this exact same bug
before :-/

> Please disable IDE in your configuration and use the PATA drivers
> instead, which are able to handle shared interrupts properly.

OK, will do. Hmm, I wonder if my previous build had this change and
after updating to 3.4 stable, I re-enabled IDE. For my work machines
(workstations and laptops) I have a single repository. I could have
enabled the IDE to get something working on another box and forgot about
it when I updated the problem workstation.

Thanks and sorry for the noise.

-- Steve


