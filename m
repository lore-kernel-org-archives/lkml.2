Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757665Ab1DIUgM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 16:36:12 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44469 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757013Ab1DIUgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 16:36:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=hy/OJxZwmlQPPQsYqIXs3mNPAJ94k4tOYw4FmBSqvp3y35kVsKxIh59PYQ0MQmkRGN
         aMImFm6jCGPFlltfsvSTIHfHWvJkA4Iv6lR3JcQyHchzlFAWcKPgYeoS3xEhEPCEpHyg
         GiBpDSa/cH2Sqx6LhIxL5RgQdAY7hH4beW6+g=
Message-ID: <4DA0C333.1050300@gmail.com>
Date: Sat, 09 Apr 2011 22:36:03 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Vasiliy Kulikov <segoon@openwall.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH] char: istallion: fix arbitrary kernel memory reads/writes
References: <1302352882-20802-1-git-send-email-segoon@openwall.com>            <4DA05EA3.5080008@gmail.com> <107257.1302380698@localhost>
In-Reply-To: <107257.1302380698@localhost>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2011 10:24 PM, Valdis.Kletnieks@vt.edu wrote:
> On Sat, 09 Apr 2011 15:26:59 +0200, Jiri Slaby said:
>> On 04/09/2011 02:41 PM, Vasiliy Kulikov wrote:
>>> stli_brdstats is defined as global variable.  After de-BKL-ization in
>>> the patch b4eda9cb48eac1b7 an access to the variable is not serialized
>>> anymore.  This leads to the TOCTOU in stli_getbrdstats():
>>
>> Don't use such a weird and uncommon abbreviations.
> 
> Time Of Check [to] Time Of Use.  Hardly uncommon, especially in the security
> community.

Well, changelogs are not for security community only. And I think I've
read far than enough papers about code analysis and never seen that before.

> Googling for 'TOCTOU' and 'TOCTTOU' gets about 60K hits combined.

Sure, I googled that a bit. But that didn't persuade me at all. It looks
like it is used by a narrow set of experts.

Whatever, I mainly wanted to point out the code move.

thanks,
-- 
js
