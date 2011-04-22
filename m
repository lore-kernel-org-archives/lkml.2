Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091Ab1DVRkj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 13:40:39 -0400
Received: from bitwagon.com ([74.82.39.175]:49698 "HELO bitwagon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756372Ab1DVRkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 13:40:37 -0400
Message-ID: <4DB1BD96.9090205@bitwagon.com>
Date: Fri, 22 Apr 2011 10:40:38 -0700
From: John Reiser <jreiser@bitwagon.com>
Organization: -
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC][PATCH 01/11] ftrace/trivial: Clean up recordmcount.c to
 use Linux style comparisons
References: <20110421022825.535486725@goodmis.org>	 <20110421023737.290712238@goodmis.org>  <4DB19A1E.8070806@bitwagon.com> <1303488826.6225.9.camel@gandalf.stny.rr.com>
In-Reply-To: <1303488826.6225.9.camel@gandalf.stny.rr.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2011 09:13 AM, Steven Rostedt wrote:
> Although, I have no idea why you choose the 0 < var, that totally
> confuses me. It does not play any role in assignments. What bug is that
> preventing? When I want to know if a variable is greater than zero, I
> don't show it as zero less than the var.

Using ">" can be confused visually with "->", and I want to reduce those
chances.  I also prefer a style that is prefix oriented, and with constants
on the left.  I mentally combine the left constant and the infix operator
into a special case prefix operator.  This speeds my parsing because it
reduces stack depth and enables faster scanning.  This is particularly
helpful when the constant is narrow and the other operand is wider.

-- 
John Reiser
