Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab3AJQOe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 11:14:34 -0500
Received: from multi.imgtec.com ([194.200.65.239]:54475 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752071Ab3AJQOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 11:14:33 -0500
Message-ID: <50EEE89D.1040405@imgtec.com>
Date: Thu, 10 Jan 2013 16:13:17 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        "Frederic Weisbecker" <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v3 39/44] metag: ftrace support
References: <1357831872-29451-1-git-send-email-james.hogan@imgtec.com>  <1357831872-29451-40-git-send-email-james.hogan@imgtec.com> <1357833597.5141.5.camel@gandalf.local.home>
In-Reply-To: <1357833597.5141.5.camel@gandalf.local.home>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_01_10_16_14_27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

On 10/01/13 15:59, Steven Rostedt wrote:
> On Thu, 2013-01-10 at 15:31 +0000, James Hogan wrote:
>> +#include <linux/ftrace.h>
>> +#include <linux/io.h>
>> +#include <linux/uaccess.h>
>> +#include <linux/ftrace.h>
> 
> duplicate <linux/ftrace.h>

Thanks, I'll fix.

> The rest looks good.

Thanks for reviewing

Cheers
James

