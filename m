Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab0IFG35 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 02:29:57 -0400
Received: from csamuel.org ([74.50.50.137]:53391 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752441Ab0IFG34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 02:29:56 -0400
Message-ID: <4C848A4E.9040103@csamuel.org>
Date: Mon, 06 Sep 2010 16:29:34 +1000
From: Chris Samuel <chris@csamuel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Lightning/1.0b2 Thunderbird/3.1.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-btrfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Jeff Moyer <jmoyer@redhat.com>,
        btrfs-devel <btrfs-devel@oss.oracle.com>,
        Andrew Morton <akpm@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        Josef Bacik <josef@redhat.com>
Subject: Re: [Btrfs-devel] [patch] O_DIRECT: fix the splitting up of contiguous
 I/O
References: <x49vd7f368c.fsf@segfault.boston.devel.redhat.com>	<20100902142501.GA14932@infradead.org>	<201009052256.12386.chris@csamuel.org> <20100905093620.d2eeb539.akpm@linux-foundation.org>
In-Reply-To: <20100905093620.d2eeb539.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/10 02:36, Andrew Morton wrote:

> On Sun, 5 Sep 2010 22:56:08 +1000 Chris Samuel <chris@csamuel.org> wrote:
> 
>> > Did this patch get dropped ? 
>
> Nope.  I have it queued for 2.6.36 and -stable, will send it in soon. 
> Everything is a bit lagged at present due to conferences, summer,
> encroaching senility, etc.

Mea culpa - I mixed up the date of the original email with the
date of Christoph's email and so thought he'd sent that back
in August.  Looks like I'm the one with senility issues.. ;-)

cheers,
Chris
-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
