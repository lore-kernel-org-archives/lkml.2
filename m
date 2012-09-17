Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540Ab2IQHy0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 03:54:26 -0400
Received: from 217-155-41-104.dsl.in-addr.zen.co.uk ([217.155.41.104]:55543
	"EHLO centos1.newflow.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754238Ab2IQHyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 03:54:25 -0400
X-Greylist: delayed 45190 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Sep 2012 03:54:25 EDT
Message-ID: <5056D71C.70209@mimc.co.uk>
Date: Mon, 17 Sep 2012 08:54:04 +0100
From: Mark Jackson <mpfj-list@mimc.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: richard -rw- weinberger <richard.weinberger@gmail.com>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Advice on mmap() "feature"
References: <505626A8.8040806@mimc.co.uk> <CAFLxGvy_VMTMZxESgDoZrOaxm94q+BeSfEb+tXeWrUc5J0gHbw@mail.gmail.com>
In-Reply-To: <CAFLxGvy_VMTMZxESgDoZrOaxm94q+BeSfEb+tXeWrUc5J0gHbw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/09/12 21:52, richard -rw- weinberger wrote:
> On Sun, Sep 16, 2012 at 9:21 PM, Mark Jackson <mpfj-list@mimc.co.uk> wrote:
>>         // now remove the mapping
>>         if (m_pFram)
>>         munmap(m_pFram, FRAM_SIZE);
> 
> You unmap less memory than you map...
> 

I hang my head in shame ... what a stupid mistake to miss !!

Thank you

