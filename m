Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507Ab1DVR5O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 13:57:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58295 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756423Ab1DVR5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 13:57:13 -0400
Message-ID: <4DB1C162.4090109@zytor.com>
Date: Fri, 22 Apr 2011 10:56:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110403 Fedora/3.1.9-6.fc15 Thunderbird/3.1.9
MIME-Version: 1.0
To: John Reiser <jreiser@bitwagon.com>
CC: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC][PATCH 01/11] ftrace/trivial: Clean up recordmcount.c to
 use Linux style comparisons
References: <20110421022825.535486725@goodmis.org>	 <20110421023737.290712238@goodmis.org>  <4DB19A1E.8070806@bitwagon.com> <1303488826.6225.9.camel@gandalf.stny.rr.com> <4DB1BD96.9090205@bitwagon.com>
In-Reply-To: <4DB1BD96.9090205@bitwagon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2011 10:40 AM, John Reiser wrote:
> On 04/22/2011 09:13 AM, Steven Rostedt wrote:
>> Although, I have no idea why you choose the 0 < var, that totally
>> confuses me. It does not play any role in assignments. What bug is that
>> preventing? When I want to know if a variable is greater than zero, I
>> don't show it as zero less than the var.
> 
> Using ">" can be confused visually with "->", and I want to reduce those
> chances.  I also prefer a style that is prefix oriented, and with constants
> on the left.  I mentally combine the left constant and the infix operator
> into a special case prefix operator.  This speeds my parsing because it
> reduces stack depth and enables faster scanning.  This is particularly
> helpful when the constant is narrow and the other operand is wider.
> 

I think you will find you're significantly in the minority when it comes
to that preference.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

