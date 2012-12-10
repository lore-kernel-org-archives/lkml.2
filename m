Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab2LJK2G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 05:28:06 -0500
Received: from multi.imgtec.com ([194.200.65.239]:52782 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754127Ab2LJK2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 05:28:03 -0500
Message-ID: <50C5B8FC.3080003@imgtec.com>
Date: Mon, 10 Dec 2012 10:27:08 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Arnd Bergmann" <arnd@arndb.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Ingo Molnar" <mingo@redhat.com>
Subject: Re: [PATCH v2 04/44] trace/ring_buffer: handle 64bit aligned structs
References: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>  <1354723742-6195-5-git-send-email-james.hogan@imgtec.com> <1354929851.17101.105.camel@gandalf.local.home>
In-Reply-To: <1354929851.17101.105.camel@gandalf.local.home>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2012_12_10_10_27_58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/12 01:24, Steven Rostedt wrote:
> On Wed, 2012-12-05 at 16:08 +0000, James Hogan wrote:
>> Some 32 bit architectures have 64 bit struct alignment (for example
>> Meta which has 64 bit read/write instructions). These require 8 byte
>> alignment of event data too, so use CONFIG_HAVE_64BIT_ALIGNED_STRUCT
>> instead of CONFIG_64BIT to decide alignment, and align
>> buffer_data_page::data accordingly.
>>
>> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> 
> Acked-by: Steven Rostedt <rostedt@goodmis.org>

Thanks Steven

Cheers
James

