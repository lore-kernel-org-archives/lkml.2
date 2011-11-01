Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab1KANA7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 09:00:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37461 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534Ab1KANA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 09:00:57 -0400
Message-ID: <4EAFED72.8000107@redhat.com>
Date: Tue, 01 Nov 2011 11:00:34 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the edac tree
References: <20111101170000.6e7301a30bc21e917631eb88@canb.auug.org.au> <4EAFDECA.3040007@redhat.com> <20111101125454.GA21877@aftab>
In-Reply-To: <20111101125454.GA21877@aftab>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 01-11-2011 10:54, Borislav Petkov escreveu:
> On Tue, Nov 01, 2011 at 07:58:02AM -0400, Mauro Carvalho Chehab wrote:
>> Sorry, it were caused by a bad merge conflict resolution. The include
>> isn't need anymore.
>>
>> The MAINTAINERS fix is indeed needed.
>>
>>> I have used the version of the edac tree from next-20111025 for today.
>>
>> I'm fixing both issues for tomorrow's next.
> 
> Btw, you're sending those to Linus soon, right?

Yes, likely tomorrow, if no surprises at linux-next merge arise.

> 
> Thanks.
> 

