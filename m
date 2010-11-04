Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887Ab0KDO0s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 10:26:48 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43826 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab0KDO0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 10:26:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=iqTdtWP3zLn5AHMPu1lJQediyxOkydzX0TPGnW2CBDjtwMg9Yhpia7riWEj0OKi2kW
         UXgQUoiSZxo7v6XVojtNQjb1ZeC8D7iJSsYBgkXOaBKMRGwRIlHlC+AMEPnjOUI1UssI
         gAAk7a/5j3s3rJCWHaOpLE5t6dQHMx/A6JjD4=
Message-ID: <4CD2C2A1.4030004@suse.cz>
Date: Thu, 04 Nov 2010 15:26:41 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.12) Gecko/20101026 SUSE/3.1.6 Thunderbird/3.1.6
MIME-Version: 1.0
To: matti.j.aaltonen@nokia.com
CC: ext Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Jari Vanhala <ext-jari.vanhala@nokia.com>
Subject: Re: mmotm 2010-10-31-21-24 uploaded (drivers/nfc/pn544)
References: <201011010427.oA14R3Y6010534@imap1.linux-foundation.org>	 <20101101110024.bca61c57.randy.dunlap@oracle.com> <1288684630.1603.102.camel@masi.mnp.nokia.com>
In-Reply-To: <1288684630.1603.102.camel@masi.mnp.nokia.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/2010 08:57 AM, Matti J. Aaltonen wrote:
> On Mon, 2010-11-01 at 11:00 -0700, ext Randy Dunlap wrote:
>> Use %zd to print ssize_t variables and %zu to print size_t:
>>
>> drivers/nfc/pn544.c:332: warning: format '%d' expects type 'int', but argument 6 has type 'size_t'
>> drivers/nfc/pn544.c:442: warning: format '%d' expects type 'int', but argument 6 has type 'size_t'
> 
> Thanks, I'll do that... I'm using Sparse and checkpatch --strict but
> neither gave me a warning about that.

You would need a 64bit compiler to emit that for size_t.

regards,
-- 
js
suse labs
