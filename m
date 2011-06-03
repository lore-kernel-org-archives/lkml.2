Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab1FCHBz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 03:01:55 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46239 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069Ab1FCHBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 03:01:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=rVF3a6aDcO/7qKjJakc+EQDAkdVeZmrpKSdOJnfc7ogkh9VSLoTuTlDTzD3dsGlwAq
         OcA0mxUGo3s4wspRNDzrjkO/oVCgr8pRysBUertk6nkEa2+FJQIYF5ZhZGIC/liAG0z2
         vda/dYnRKJMthNVPkT8dZDW9Ja/kopacElaWY=
Message-ID: <4DE886DC.1040807@gmail.com>
Date: Fri, 03 Jun 2011 09:01:48 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0a2) Gecko/20110420 Thunderbird/3.3a4pre
MIME-Version: 1.0
To: Joe Pranevich <jpranevich@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Linux 3.0 change listings - Wonderful World of Linux 3.0
References: <BANLkTikvU-XUu9sWX-E87a7CUtA7j+ZRpA@mail.gmail.com>
In-Reply-To: <BANLkTikvU-XUu9sWX-E87a7CUtA7j+ZRpA@mail.gmail.com>
X-Enigmail-Version: 1.2a1pre
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2011 09:59 PM, Joe Pranevich wrote:
> Happy Memorial Day! I'm a day later than I said that I would be, but I
> have attached a first draft of the "Wonderful World of Linux 3.0"
> document. Please take a look and I hope that you find this helpful,
> but I also hope that it can be a place that individuals not associated
> with kernel development can turn to find out what is new in the
> release. (With "new" being relative, of course. With no dev release,
> these features have been available already.)
> 
> Good thing I didn't post it yesterday anyway, since I was still
> calling it Linux 2.8. :)
> 
> Please take a look at this and let me know if I should make any
> corrections. I appreciate your help.

Hi, what about static analysis and found bugs? There appeared a lot of
tools which were first run on the 2.6 kernel and wiped out many kind of
bugs. This includes imbalanced locking, NULL/dangling pointer
dereferences, . I don't think that for example Coverity was ever run on
linux-2.4 or 2.5. I for sure know, that linux kernel verification
project, smatch, stanse and coccinelle didn't even exist before 2.6.

So 3.0 in fact should be safer, at least in many paths which are barely
tested otherwise -- fail and go-here-once-in-a-year paths.

regards,
-- 
js
