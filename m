Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030Ab1AKNPu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 08:15:50 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:40473 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009Ab1AKNPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 08:15:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=SYNUuSPM4OwCEXp4DGz68J1l6T5Yiz5SdPsCncVmu0OHyN3ogkxj2kXnmwl+3iit0A
         9HGvElBkOTWxAYFUF8SHgRoBXXmwbIPLlj5BVsH9aJgckZefsCgAgktDuA/LbAqf2Mh6
         JhgdnI5GZNpLncCO89EJqO/hH/znjAamOT8xA=
Date: Tue, 11 Jan 2011 21:14:23 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Piotr Hosowicz <piotr@hosowicz.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Error in linux-2.6.37-git5 in btrfs in ctree.c
Message-ID: <20110111131423.GA17312@hack>
References: <4D2C52E3.2020702@example.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4D2C52E3.2020702@example.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 01:53:55PM +0100, Piotr Hosowicz wrote:
>(I send again because my previous message wasn't delivered.)
>
>Hello,
>
>There is an error in here:
>
>In file included from fs/btrfs/ctree.c:21:
>fs/btrfs/ctree.h:1003: error: field ‘super_kobj’ has incomplete type
>fs/btrfs/ctree.h:1074: error: field ‘root_kobj’ has incomplete type
>
>Kernel fails to build. linux-2.6.37-git5
>

I saw this too, just adding "<linux/kobject.h>" to ctree.h will
fix this error.

I have a patch but it is not on this laptop. :-/


-- 
Live like a child, think like the god.
 
