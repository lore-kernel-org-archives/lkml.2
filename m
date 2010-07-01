Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847Ab0GART7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 13:19:59 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:40063 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab0GART6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 13:19:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ivM3kRXu2Tr3pZhyLsO5+/K/g3Vjjq3BvHKGbyRqTTsu7MUBQ5+Vp6TWTGAofy7B+L
         zpAFys+VAgCOcoryw1onRWryPHS+cy9mNMs8HPa6JgS6pjt5F50LraWWZEugdJ9mE5Aw
         1+AE7HXo6z4G6PCD8P1hfThRIrnzTOA17uxT8=
Message-ID: <4C2CCE57.40208@gmail.com>
Date: Thu, 01 Jul 2010 10:20:23 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100615 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, jkosina@suse.cz
Subject: Re: [PATCH]kernel.h Move warning message about using kernel headers
 for userspace to types.h
References: <1277935785-6023-1-git-send-email-justinmattock@gmail.com> <201007010958.46720.arnd@arndb.de> <4C2C9962.3080307@gmail.com> <201007011707.31783.arnd@arndb.de>
In-Reply-To: <201007011707.31783.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o.k. I resent an updated version. keep in mind this is a bit confusing 
with the __KERNEL__ being in there multiple times, but with the v2 I'm 
able to see the #warning message with my little program.

As for the patch itself hopefully I corrected it's changelog etc..
lately I've been a bit confused with the whole sighned off thing i.g.
you suggested the #else so naturally I should add your name with a 
sighned off, but with other patches I was told not to do so due to the 
sighned off procedure/process. I'll re-read the submitting patches again 
to make sure.

hopefully I get this right..

Justin P. Mattock
