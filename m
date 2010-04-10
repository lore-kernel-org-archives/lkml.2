Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751496Ab0DJIrW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 04:47:22 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:63986 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924Ab0DJIrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 04:47:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=NOzOTp6IewZIaN6Wed9CvAqL/Urn4ofyVwA24dnc8bXzuzbSQ2af220Q/O5Q/C/HP1
         TWhbEIFIhq9m3xMC+AjyONrcgmlcNMU7r6ies9VikpfOVX2clh8AeniGDPwpnfGMKw4f
         NBS1Rki47BMCvs3k7qRjXyyVVji9bvhq/izik=
Message-ID: <4BC03B16.6000403@gmail.com>
Date: Sat, 10 Apr 2010 10:47:18 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.2pre) Gecko/20100308 SUSE/3.1b1-6.2 Thunderbird/3.1b1
MIME-Version: 1.0
To: maciej.rutecki@gmail.com
CC: Jiri Kosina <jkosina@suse.cz>, Pavel Machek <pavel@ucw.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.34-rc3 doesn't suspend to disk (-rc2 did)
References: <alpine.LNX.2.00.1004020215100.8345@pobox.suse.cz> <201004082044.26949.maciej.rutecki@gmail.com> <4BC03A11.4050407@gmail.com>
In-Reply-To: <4BC03A11.4050407@gmail.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2010 10:42 AM, Jiri Slaby wrote:
> Jiri, could you add there whether you changed config options somehow?
> The bug drives me crazy.

(and check whether the fix there solves your problem or we hit different
issues)

-- 
js
