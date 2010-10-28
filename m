Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760949Ab0J1SRQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 14:17:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30067 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755321Ab0J1SRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 14:17:06 -0400
Message-ID: <4CC9BE09.4060003@redhat.com>
Date: Thu, 28 Oct 2010 13:16:41 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: "Ted Ts'o" <tytso@mit.edu>, Markus Trippelsdorf <markus@trippelsdorf.de>,
        sedat.dilek@gmail.com, LKML <linux-kernel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, sfr@canb.auug.org.au,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [next-20101038] Call trace in ext4
References: <AANLkTi=E_uMj_ndGU86DCjX4aDwjHqg3dkwxjQRSJtq6@mail.gmail.com> <20101028175221.GA1578@arch.trippelsdorf.de> <20101028180118.GC6814@thunk.org>
In-Reply-To: <20101028180118.GC6814@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ted Ts'o wrote:
> On Thu, Oct 28, 2010 at 07:52:21PM +0200, Markus Trippelsdorf wrote:
>> The same BUG (inode.c:2721) happend here today running latest vanilla
>> git. There is nothing in my logs unfortunately, but I shot a photo of
>> the trace (see attachment).
> 
> I see, it's the page_buffers() call which is triggering.  Looking into
> it...
> 
> 							- Ted

Same bug that Avinash Kurup reported, right.

-Eric
