Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185Ab1JASpq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 14:45:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:42173 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588Ab1JASpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 14:45:39 -0400
X-Authority-Analysis: v=1.1 cv=XWD5/VRj2HUJOhsR8cgmvPBlhMACpZXxseY1Kn/ehQI= c=1 sm=0 a=eaZrqAE3U5cA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=ktNasmvQAAAA:8 a=7foTBo4djsokKBqomqEA:9 a=PUjeQqilurYA:10 a=WjqgFE--SJEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: kernel.org status: hints on how to check your machine for
 intrusion
From: Steven Rostedt <rostedt@goodmis.org>
To: David Miller <davem@davemloft.net>
Cc: w@1wt.eu, greg@kroah.com, linux-kernel@vger.kernel.org
Date: Sat, 01 Oct 2011 14:45:38 -0400
References: <20110930235924.GA25176@kroah.com>
	 <20111001073533.GA18690@1wt.eu> <20111001180641.GD6309@home.goodmis.org>
	 <20111001.141343.2293070262147973147.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1317494738.4588.78.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-10-01 at 14:40 -0400, Steven Rostedt wrote:
> OK, I decided to attach the perl script anyway. It is very crude, and
> really needs to be cleaned up for generic use.
> 

I've just been pointed to:

http://www.fail2ban.org/wiki/index.php/Main_Page

This looks like something similar.

You see, the reason I posted this tool is because I was sure people will
point me to better ones that do the same thing (and more!)   ;)

-- Steve


