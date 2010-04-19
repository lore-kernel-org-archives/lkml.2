Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373Ab0DSUSM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 16:18:12 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:65127 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab0DSUSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 16:18:10 -0400
Message-ID: <4BCCB9F1.8060709@oracle.com>
Date: Mon, 19 Apr 2010 13:15:45 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: John Kacur <jkacur@redhat.com>
CC: Steven Rostedt <rostedt@goodmis.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: trace-cmd: make Makefile rpm-friendly
References: <20100419100058.6f1457dd.randy.dunlap@oracle.com> <alpine.LFD.2.00.1004191942010.4111@localhost.localdomain> <1271703972.10448.5.camel@gandalf.stny.rr.com> <alpine.LFD.2.00.1004192200570.4111@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1004192200570.4111@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090205.4BCCBA74.0004:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/10 13:06, John Kacur wrote:
> 
> Yeah, the above is actually an unsatisfactory workaround.
> see 7ae5f21361fea11f58c398701da635f778635d13
> 
> Another solution is to not copy obfuscated Makefiles when starting new
> projects!

Very much agreed.

> /me runs away


-- 
~Randy
