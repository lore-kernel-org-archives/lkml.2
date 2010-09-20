Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722Ab0ITPlD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 11:41:03 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47522 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208Ab0ITPlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 11:41:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=vHlHfB2Elivzvin7IXkqoYTxb38z+Meg4lE50hcvUsmhzdxNh1SJ3llcHSzqm3HQCy
         KERDdL6h8OXv+hwcAZyZ3znL4W76bTVU3QAAzNcud456V9PmgWq6WnvrFkgNYT9ZnAzM
         N5BmDf2qxxHONr0ZabdTxZUr8+pr3XYNbiWF8=
Message-ID: <4C978087.7060802@gmail.com>
Date: Mon, 20 Sep 2010 21:40:55 +0600
From: "Alexander E. Patrakov" <patrakov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100911 Lightning/1.0b3pre Thunderbird/3.1.3
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] BKL: Remove BKL from isofs
References: <201009161632.59210.arnd@arndb.de> <201009172100.06598.arnd@arndb.de> <20100920105811.GC3390@quack.suse.cz> <201009201313.11526.arnd@arndb.de> <20100920151834.GF3390@quack.suse.cz>
In-Reply-To: <20100920151834.GF3390@quack.suse.cz>
Content-Type: text/plain; charset=windows-1251; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[I know nothing about linux filesystem code, please disregard this mail 
if it is stupid]

20.09.2010 21:18, Jan Kara wrote:

> BKL isn't needed for isofs at all so we can just remove it. Generally, since
> isofs is always mounted read-only, filesystem structure cannot change under us.

Does your statement also cover the case of read errors on scratched 
CD-ROMs (i.e., the driver has successfully read a sector with a 
directory once after a lot of strugging, and failed the next time), or 
ejects of mounted media?

-- 
Alexander E. Patrakov
