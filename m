Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab2EGDGJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 23:06:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38223 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755205Ab2EGDGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 23:06:08 -0400
Message-ID: <4FA73C14.4090709@zytor.com>
Date: Sun, 06 May 2012 20:05:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, ralf@linux-mips.org
Subject: Re: [PATCH] broken TASK_SIZE for ia32_aout
References: <af01067e-5a22-44a8-acb1-368e45dbb06c@email.android.com> <20120506.194037.1148847080889462521.davem@davemloft.net> <8c91e0ff-dc31-4f94-8008-33d8c3d3c8ef@email.android.com> <20120506.225639.74405234456670944.davem@davemloft.net>
In-Reply-To: <20120506.225639.74405234456670944.davem@davemloft.net>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2012 07:56 PM, David Miller wrote:
> From: "H. Peter Anvin" <hpa@zytor.com>
> Date: Sun, 06 May 2012 16:48:00 -0700
> 
>> Why not just make it illegal to make the system calls you don't care
>> about then, to prevent any security issue?
> 
> I'll take a closer look tomorrow.
> 
> BTW, when did you start top-posting? :-/

Just when on a cell phone...

	-hpa

