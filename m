Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898Ab0CXVbO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 17:31:14 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:25895 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554Ab0CXVbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 17:31:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=EsvL9lYZo4UWpC35DwjVZrFjtuGgQCxZffDtlw3sSPVr3fd43EVXKHQ6silxHKbdXF
         CVnw5duSP4enYdeC+kjoqeGKvCZdXOYfRGWUGbD/q5UhC/ESy8FLIR5lXlaorlXmijVK
         TprlPt2ir+zpGiw3L1pNPdukHsLzNYE0gBrgY=
Message-ID: <4BAA849D.1080308@gmail.com>
Date: Wed, 24 Mar 2010 22:31:09 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.2pre) Gecko/20100308 SUSE/3.1b1-5.9 Thunderbird/3.1b1
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Nigel Cunningham <ncunningham@crca.org.au>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC 07/15] PM / Hibernate: add sws_modules_ops
References: <1269361063-3341-1-git-send-email-jslaby@suse.cz> <1269361063-3341-7-git-send-email-jslaby@suse.cz> <20100324203634.GH5798@elf.ucw.cz>
In-Reply-To: <20100324203634.GH5798@elf.ucw.cz>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2010 09:36 PM, Pavel Machek wrote:
> On Tue 2010-03-23 17:17:35, Jiri Slaby wrote:
>> +struct sws_module_ops {
...
> sws_ prefix is strange.

Yeah, noted on this in the previous mail.

> Plus, could we get some docs what it does? Stuff like "get_writer" is
> not entirely self-documenting.

Ah, this I wanted to do. Thanks for the reminder.

-- 
js
