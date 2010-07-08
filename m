Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039Ab0GHN2b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 09:28:31 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:60053 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751930Ab0GHN23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 09:28:29 -0400
Message-ID: <4C35D264.7080809@metafoo.de>
Date: Thu, 08 Jul 2010 15:28:04 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Ralf Baechle <ralf@linux-mips.org>, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH v2 16/26] fbdev: Add JZ4740 framebuffer driver
References: <1276924111-11158-1-git-send-email-lars@metafoo.de>        <1276924111-11158-17-git-send-email-lars@metafoo.de>        <4C310ACD.6040604@metafoo.de> <20100707164148.d2a1f8c4.akpm@linux-foundation.org>
In-Reply-To: <20100707164148.d2a1f8c4.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 05 Jul 2010 00:27:25 +0200
> Lars-Peter Clausen <lars@metafoo.de> wrote:
> 
>> Hi Andrew
>>
>> v2 of this patch has been around for two weeks without any comments. I've fixed all
>> the issues you had with v1. If you this version is ok, an Acked-By would be nice :)
> 
> I don't do acks - I already have enough to be blamed for.
Hm, ok.

> Although I might whine about inappropriate use of
> ENOENT, which means "No such file or directory".
> 

That is due to to many bad examples, I guess. Would using ENXIO instead keep you from
whining?

- Lars

