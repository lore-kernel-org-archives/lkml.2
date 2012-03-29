Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758867Ab2C2DQi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 23:16:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60202 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758287Ab2C2DQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 23:16:34 -0400
Message-ID: <4F73D405.6040805@zytor.com>
Date: Wed, 28 Mar 2012 20:16:21 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        David Sharp <dhsharp@google.com>,
        Justin Teravest <teravest@google.com>,
        Laurent Chavey <chavey@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] trace: trace syscall in its handler not from ptrace
 handler
References: <1332787168-20457-1-git-send-email-vnagarnaik@google.com> <1332787168-20457-5-git-send-email-vnagarnaik@google.com> <4F714982.6020208@zytor.com> <CAL26m8Jfb8bgfDLKZtn2LkYHD6uCccD3UcsSMbHtpnUKR5_mxw@mail.gmail.com> <4F73CC3A.2080901@zytor.com> <CAL26m8+zbbqngfK0fYb+A2UBQ1fZ9Uxrf4VLWqU1VuMzkcF4xw@mail.gmail.com>
In-Reply-To: <CAL26m8+zbbqngfK0fYb+A2UBQ1fZ9Uxrf4VLWqU1VuMzkcF4xw@mail.gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2012 08:02 PM, Vaibhav Nagarnaik wrote:
> 
> But if it doesn't seem to help, then I will not push this patch.
> 

Consider this patch and anything even remotely like it NAKed with
extreme prejudice.

	-hpa

