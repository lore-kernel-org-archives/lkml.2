Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751288Ab0DJInJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 04:43:09 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:38142 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab0DJInC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 04:43:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=kcbiLyVe+njKE9OHab10UvY03RTExZ8iice5X3GYjm8ybvfWl5ODBjJfCosT9obRyM
         hhlKAn3sfZO+YowVxmHZqFgmiogioW3pzuGqKPOqYvOpLjYewObOJALH1p24QcUpHYOk
         stMFauB6LqpVNv/AJsoXBg74PggG/lyYTXD+I=
Message-ID: <4BC03A11.4050407@gmail.com>
Date: Sat, 10 Apr 2010 10:42:57 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.2pre) Gecko/20100308 SUSE/3.1b1-6.2 Thunderbird/3.1b1
MIME-Version: 1.0
To: maciej.rutecki@gmail.com
CC: Jiri Kosina <jkosina@suse.cz>, Pavel Machek <pavel@ucw.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.34-rc3 doesn't suspend to disk (-rc2 did)
References: <alpine.LNX.2.00.1004020215100.8345@pobox.suse.cz> <201004082044.26949.maciej.rutecki@gmail.com>
In-Reply-To: <201004082044.26949.maciej.rutecki@gmail.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2010 08:44 PM, Maciej Rutecki wrote:
> On piątek, 2 kwietnia 2010 o 02:19:26 Jiri Kosina wrote:
>> Hi,
>>
>> I have just hit this problem. Haven't bisected it yet, and going through
>> shortlog doesn't ring any bell immediately, so I am sending this out in
>> case it rings a bell for someone right away.
> 
> I created a Bugzilla entry at 
> https://bugzilla.kernel.org/show_bug.cgi?id=15728

Jiri, could you add there whether you changed config options somehow?
The bug drives me crazy.

thanks,
-- 
js
