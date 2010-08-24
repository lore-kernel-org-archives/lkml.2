Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab0HXIYm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 04:24:42 -0400
Received: from r-mail2.rd.francetelecom.com ([217.108.152.42]:45012 "EHLO
	r-mail2.rd.francetelecom.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751710Ab0HXIYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 04:24:38 -0400
Message-ID: <4C738084.2080309@Free.fr>
Date: Tue, 24 Aug 2010 10:19:16 +0200
From: Eric Valette <Eric.Valette@Free.fr>
Reply-To: Eric.Valette@Free.fr
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.8) Gecko/20100821 Lightning/1.0b2 Icedove/3.1.2
MIME-Version: 1.0
To: Florian Mickler <florian@mickler.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: Please add generic support for root=UUID= at kernel parameter
 command line (LABEL, BYID maybe also)
References: <4C728145.4030808@Free.fr> <20100823220506.7248c51b@schatten.dmk.lab>
In-Reply-To: <20100823220506.7248c51b@schatten.dmk.lab>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Aug 2010 08:19:16.0957 (UTC) FILETIME=[0B3E20D0:01CB4365]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/08/2010 22:05, Florian Mickler wrote:

> I'm not exactly shure, but isn't the search command in grub2 what you
> want?
>
> http://forums.linuxmint.com/viewtopic.php?f=46&t=38599
>
> You can let grub2 figure out which drive is which and pass the right
> devices to the kernel...
>

It helps finding the grub root partition, not how linux kernel will name 
it. It replaces the classical root=(hd0,0) command. BTW grubs always 
works and find the /boot/grub partition and load linux but linux does 
not manage to find init.

But thanks for helping anyway.

--eric


