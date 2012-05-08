Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923Ab2EHVKk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 17:10:40 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:46258 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755505Ab2EHVKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 17:10:39 -0400
X-Sasl-enc: a75D59snfokuU5y3hQNHJgtrKAzKPSMsM6FunNKaAWt+ 1336511438
Message-ID: <4FA98BCC.1020404@fastmail.fm>
Date: Tue, 08 May 2012 22:10:36 +0100
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: wilson self <wself00@gmail.com>
CC: linux-kernel@vger.kernel.org, gilad@benyossef.com, fweisbec@gmail.com
Subject: Re: Work queues and cpu isolation
References: <CAAZUjxBp7f_Tt3bXSOcac6RmeT23npELYO52P_2LdMN-MdH=7g@mail.gmail.com>
In-Reply-To: <CAAZUjxBp7f_Tt3bXSOcac6RmeT23npELYO52P_2LdMN-MdH=7g@mail.gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Adding CCs]

On 05/08/2012 10:03 PM, wilson self wrote:
> I have done some reading on the subject of work queues and CPU
> isolation, and specifically I've read a number of posts from Max K.
> dating back to 2008 on the subject of CPU isolation.  However, I have
> not seen much in the way of discussion on the subject in more recent
> times, specifically in the 3.x kernels; where it appears there are
> some significant differences in the structure of workqueue in general.
> 
> Is there anyone currently doing work on additional isolation of CPUs
> from work queues? I have some requirement to further isolate cores on
> a machine from these queues and am hoping someone here could point me
> in the right direction.
> 
> Thanks.
> wilson

