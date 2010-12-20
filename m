Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382Ab0LTJwj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 04:52:39 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:46983 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755175Ab0LTJwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 04:52:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=wzZsOIEi6DNQCnvtSIE04vO33pR3/Vooc6U27S8D6fBZMjHiZyUQPA55GbuI4LDji2
         xu8vo9+9d4kfm0ttOx1UcOdvHK6tnHoVruqRIB3o9a/yDpHkDC/m32YqQwcth/X79KCx
         EGpGvx0t4H1/85DfSLGiXEziqQwxO+jyD//Mg=
Message-ID: <4D0F2760.6070203@gmail.com>
Date: Mon, 20 Dec 2010 10:52:32 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        dri-devel@lists.freedesktop.org
Subject: Re: i915 modeset defunct [was: mmotm 2010-12-16-14-56 uploaded]
References: <201012162329.oBGNTdPY006808@imap1.linux-foundation.org> <4D0F26AE.9010205@gmail.com>
In-Reply-To: <4D0F26AE.9010205@gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2010 10:49 AM, Jiri Slaby wrote:
> On 12/16/2010 11:56 PM, akpm@linux-foundation.org wrote:
>> The mm-of-the-moment snapshot 2010-12-16-14-56 has been uploaded to
> 
> Hi, there is a regression against 2010-12-02-16-34 in i915. When modeset
> is used, my G33 produces no signal to the monitor (black screen, power
> led blinks).
...
> any ideas?

Oh, looks like:
https://bugzilla.kernel.org/show_bug.cgi?id=25242

regards,
-- 
js
