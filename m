Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932491Ab1C3NTx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 09:19:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:47692 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932157Ab1C3NTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 09:19:52 -0400
X-Authority-Analysis: v=1.1 cv=aqMe+0lCtaYvy4h0jyaoPGyq+DPF+P6rPG2xbekoY9Q= c=1 sm=0 a=XYJHFtupD_QA:10 a=_1REmzv8xjcA:10 a=8nJEP1OIZ-IA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=-j4potA_lYyAumOTwkwA:9 a=HvC47gylbIE-S7Yr3aJDaegfEXoA:4 a=wPNLvfGTeEIA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Wed, 30 Mar 2011 09:19:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Keval Vora <kevalvora@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Compiling kernel 2.6.12
Message-ID: <20110330131951.GI8529@home.goodmis.org>
References: <AANLkTi=9kaSJ6hOa6rB7QScSa-aStf45cHA_HNASicUP@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=9kaSJ6hOa6rB7QScSa-aStf45cHA_HNASicUP@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 10:38:33AM +0530, Keval Vora wrote:
> Hello
> 
> I was trying to compile the kernel 2.6.12. The command "make O=/build
> menuconfig" executed successfully. However I am getting the following
> error on executing "make O=/build":
> 
> operand type mismatch for `mov'
> 
> I am a student and I particularly wanted to compile this version
> because there are few patches coded for this version I need to study
> them and may be extend them. Can anyone please help me with this one?
> 

2.6.12 is a very old kernel and probably wont even build with the latest
toolchains, as now the tool chains will error on things that it use to
let by back then.

You'll probably want to try and find a version of a distro from 2005 and
install that on a machine. Then you could build the 2.6.12 kernel on
that distro. You may need to also find a machine from 2005 as well.

Good luck,

-- Steve

