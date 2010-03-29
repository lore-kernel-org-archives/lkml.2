Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761Ab0C2OHg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 10:07:36 -0400
Received: from server109i.appriver.com ([72.32.253.93]:2080 "EHLO
	server109.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752358Ab0C2OHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 10:07:35 -0400
X-Policy: GLOBAL - intcomgrp.com
X-Primary: jkosin@intcomgrp.com
X-Note: This Email was scanned by AppRiver SecureTide
X-ALLOW: JKosin@intcomgrp.com ALLOWED
X-Virus-Scan: V-
X-Note: Spam Tests Failed: 
X-Country-Path: PRIVATE->UNITED STATES->UNITED STATES
X-Note-Sending-IP: 216.54.13.100
X-Note-Reverse-DNS: mail.intcomgrp.com
X-Note-WHTLIST: JKosin@intcomgrp.com
X-Note: User Rule Hits: 
X-Note: Global Rule Hits: G179 G180 G181 G182 G186 G187 G198 G285 
X-Note: Encrypt Rule Hits: 
X-Note: Mail Class: ALLOWEDSENDER
X-Note: Headers Injected
Message-ID: <4BB0B472.7060705@intcomgrp.com>
Date: Mon, 29 Mar 2010 10:08:50 -0400
From: James Kosin <jkosin@intcomgrp.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.8) Gecko/20100227 Lightning/1.0b1 Thunderbird/3.0.3
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: EDAC: Is it possible to calculate which piece of memory is bad?
References: <etnvQ-1Mn-3@gated-at.bofh.it>
In-Reply-To: <etnvQ-1Mn-3@gated-at.bofh.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Mar 2010 14:08:50.0681 (UTC) FILETIME=[5B6B6E90:01CACF49]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/29/2010 9:50 AM, Justin Piszcz wrote:
> Hello,
> 
> I see the following errors:
> 
> EDAC MC0: CE page 0x8abba, offset 0xa10, grain 8, syndrome 0x4758, row
> 0, channel 0, label "": k8_edac
> EDAC MC0: CE - no information available: k8_edac Error Overflow set
> EDAC k8 MC0: extended error code: ECC chipkill x4 error
> EDAC k8 MC0: general bus error: participating processor(local node
> origin), time-out(no timeout) memory transaction type(generic read), mem
> or i/o(mem access), cache level(generic)
> 
> Is it possible to use the page or offset to calculate which DIMM is
> having a
> problem?
> 
> Justin.
> 

Theoretically, YES.

However, you would have to have some important information:
1)  The number and size of each memory stick in the machine.
2)  The physical location accessed.  With virtual memory being the norm
there isn't always a 1-1 mapping here.  But, this should be attainable.

James
