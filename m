Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932393Ab1GOEyr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 00:54:47 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:30853 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932118Ab1GOEyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 00:54:46 -0400
X-RZG-AUTH: :IGUXYVOIf/Z0yAghYbpIhzghmj8icP68r1arC3zTx2B9G7/X5zri/u5Y1+fsZ6BmRA==
X-RZG-CLASS-ID: mo00
Message-ID: <4E1FC808.4070802@die-jansens.de>
Date: Fri, 15 Jul 2011 06:54:32 +0200
From: Arne Jansen <lists@die-jansens.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, greg@kroah.com, joe@perches.com,
        rdunlap@xenotime.net, kongjianjun@gmail.com
Subject: Re: [RFC]Question about codes comments
References: <20110715034745.GA3771@gmail.com>
In-Reply-To: <20110715034745.GA3771@gmail.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.07.2011 05:47, Harry Wei wrote:
> Hi all,
> When i read the kernel codes, i always find the code comments with
> /* XXX ..... */. The 'XXX' turns to be colourful. It is with croci.
> I don't know the meaning of 'XXX'? Can anyone tell me?

It is just a marker that there's still some work to do, like
FIXME, TODO, and HERE. Normally you set this marker
to be able to find all those places easily by a simple search.
The marker should at least be accompanied by an explanatory
text.

> 
> Thanks in advance
> Harry Wei
> --
