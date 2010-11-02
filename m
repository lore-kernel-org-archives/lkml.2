Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903Ab0KBUGg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 16:06:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58339 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081Ab0KBUGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 16:06:35 -0400
Message-ID: <4CD06F2C.1050504@zytor.com>
Date: Tue, 02 Nov 2010 16:06:04 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: monstr@monstr.eu
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        davem@davemloft.net, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/locking] xilinx_emaclite: netpoll support
References: <tip-357e8b5f723ba9e1d0a0f8ffb1361d607e43e19a@git.kernel.org> <4CCFCF0B.9010507@monstr.eu>
In-Reply-To: <4CCFCF0B.9010507@monstr.eu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/2010 04:42 AM, Michal Simek wrote:
>
> It is in the mainline.
>

All of master.kernel.org got rolled back due to a botched upgrade (now 
mostly fixed), then Ingo pushed a tree, which made the robot think that 
everything was a new commit, and it went crazy.

Terribly sorry about this... needless to say, this was a pretty sizable 
disaster on a lot of fronts.

	-hpa

