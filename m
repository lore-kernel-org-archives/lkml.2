Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757875Ab0JXQS6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 12:18:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48574 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754820Ab0JXQS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 12:18:57 -0400
Message-ID: <4CC45C6C.6030006@redhat.com>
Date: Sun, 24 Oct 2010 18:18:52 +0200
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100914 Thunderbird/3.1.3
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: jaxboe@fusionio.com, linux-kernel@vger.kernel.org
Subject: Re: loop warnings in current git HEAD
References: <20101023155950.GA31946@lst.de> <4CC4043F.1070605@redhat.com> <20101024161323.GA32405@lst.de>
In-Reply-To: <20101024161323.GA32405@lst.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2010 06:13 PM, Christoph Hellwig wrote:
> On Sun, Oct 24, 2010 at 12:02:39PM +0200, Milan Broz wrote:
>> yes, seems I forgot bdev can be NULL in destructor (autoclear mode).
>> can you try if patch below helps?
> 
> Yes, this patch seems to fix the issue for me.

Great.

Jens, please can you queue it to block git then?

Btw there seems to be other loop problem I just found (not related to my patch)
when loop compiled as module oopses on unload, I'll try to bisect it.

Milan

