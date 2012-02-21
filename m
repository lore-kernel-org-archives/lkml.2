Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146Ab2BUTaU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 14:30:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45013 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472Ab2BUTaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 14:30:19 -0500
Message-ID: <4F43F0C0.5050104@zytor.com>
Date: Tue, 21 Feb 2012 11:30:08 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: "H. Peter Anvin" <hpa@linux.intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Do the x86 kernel entry points need an xabort on TSX cpus?
References: <CALCETrVWBdp2yyuZ54osq_QQ0a8NKUfOk8stxtuiFWq76FO7JQ@mail.gmail.com> <4F35517F.9070904@linux.intel.com> <CALCETrVHpfW5=paX8XjGNBg3Q7sjeLptMBG6bW=iQpXk0Uo+PA@mail.gmail.com>
In-Reply-To: <CALCETrVHpfW5=paX8XjGNBg3Q7sjeLptMBG6bW=iQpXk0Uo+PA@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2012 09:24 AM, Andy Lutomirski wrote:
> 
> Is that architecturally guaranteed?  (My manual suggests that it's 
> specifically *not* guaranteed, which is surprising.)
> 

I asked internally for a statement, and got the following:

"Intel does not expect operating systems to require XABORT at the entry
points.  Intel takes system security extremely seriously and that any
functionality added is scrutinized for security implications."

	-hpa

