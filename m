Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462Ab0CXVWq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 17:22:46 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:55350 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540Ab0CXVWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 17:22:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=dbYKPujDd8Ty4jAPm0e6MlFE7sUhr+mTVeoBEZXycIED6C2wCGzTWXgV2f+51Ti+qO
         9Lt1IXPZxE0/PScdEMAGjyG6O/Lppb5Pt1nmgJiHBR7EDPJSfS++mco+yqudbovZ7+V0
         AIO4Wu3+g7a/WB4ktimScwoi9ZSqFIxbE3ltU=
Message-ID: <4BAA829F.7060207@gmail.com>
Date: Wed, 24 Mar 2010 22:22:39 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.2pre) Gecko/20100308 SUSE/3.1b1-5.9 Thunderbird/3.1b1
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Nigel Cunningham <ncunningham@crca.org.au>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC 03/15] PM / Hibernate: separate block_io
References: <1269361063-3341-1-git-send-email-jslaby@suse.cz> <1269361063-3341-3-git-send-email-jslaby@suse.cz> <20100324203021.GE5798@elf.ucw.cz>
In-Reply-To: <20100324203021.GE5798@elf.ucw.cz>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2010 09:30 PM, Pavel Machek wrote:
> On Tue 2010-03-23 17:17:31, Jiri Slaby wrote:
>> +int sws_bio_read_page(pgoff_t page_off, void *addr, struct bio **bio_chain)
>> +{
>> +	return submit(READ, sws_resume_bdev, page_off * (PAGE_SIZE >> 9),
>> +			virt_to_page(addr), bio_chain);
>> +}
> 
> sws_ is kind of strange prefix. We were trying to get away from
> "swsuspend" name for quite some time...

No problem to change the prefix to anything else. Do you (anybody)
suggest anything?

-- 
js
