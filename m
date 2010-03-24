Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768Ab0CXLf0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 07:35:26 -0400
Received: from mail-ew0-f216.google.com ([209.85.219.216]:40273 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755369Ab0CXLfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 07:35:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=F5fuLW1nSNZSBzS9y0DxWeltEsECT/496kyG7f03oakzQymrIkv6jzXD0YBtJdtQHP
         DRcT8wifF5OAzrIYe/ek0TUFC+/ZytUT/dcRFn6IfNtFqg+Z89ZmM2NoO3nq3NA3Ugdb
         GJ3CAJ37pLyMaNcLH6nEzb4RgT03fgAS6tHu4=
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Ferenc Wagner <wferi@niif.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org
Subject: Re: RFC: direct MTD support for SquashFS
References: <87vdcwv139.fsf@tac.ki.iif.hu>
	<87ljdsibqe.fsf@macbook.be.48ers.dk> <87r5nhziss.fsf@tac.ki.iif.hu>
	<bffbecbb1003181440kc78f4dbvd25d4e2ea17b52e5@mail.gmail.com>
	<8739zqpxxw.fsf@tac.ki.iif.hu> <4BA9A1BB.4000105@lougher.demon.co.uk>
	<87y6hii5wq.fsf@macbook.be.48ers.dk> <871vfam00k.fsf@tac.ki.iif.hu>
Date: Wed, 24 Mar 2010 12:35:21 +0100
In-Reply-To: <871vfam00k.fsf@tac.ki.iif.hu> (Ferenc Wagner's message of "Wed,
	24 Mar 2010 12:28:43 +0100")
Message-ID: <87ljdihs06.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Ferenc" == Ferenc Wagner <wferi@niif.hu> writes:

Hi,

 >> Again, what kind of size reduction can we expect from getting rid of
 >> the block layer?

 Ferenc> My size-optimized OpenWRT vmlinux shrank ~170 kB after disabling
 Ferenc> CONFIG_BLOCK.  Similarly for the memory consumption.

Neat, thanks - That sounds worthwhile.

-- 
Bye, Peter Korsgaard
