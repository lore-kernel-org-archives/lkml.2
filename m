Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783Ab1DLJBt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 05:01:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33103 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753303Ab1DLJBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 05:01:48 -0400
Message-ID: <4DA414F7.1090302@suse.cz>
Date: Tue, 12 Apr 2011 11:01:43 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
Cc: jwjstone@fastmail.fm, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] kbuild: Allow to override LINUX_COMPILE_BY and LINUX_COMPILE_HOST
 macros
References: <4D9B3AA4.5090402@fastmail.fm>            <1302534289-17689-1-git-send-email-mmarek@suse.cz> <18001.1302578757@localhost>
In-Reply-To: <18001.1302578757@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.4.2011 05:25, Valdis.Kletnieks@vt.edu wrote:
> On Mon, 11 Apr 2011 17:04:49 +0200, Michal Marek said:
>> Make it possible to override the user@host string displayed during boot
>> and in /proc/version by the environment variables KBUILD_BUILD_USER and
>> KBUILD_BUILD_HOST. 
> 
>> +
>> +KBUILD_BUILD_TIMESTAMP
> 
> Changelog section doesn't match actual patch.  Other than that, I'm OK on this.

I changed it to

  Make it possible to override the user@host string displayed during boot
  and in /proc/version by the environment variables KBUILD_BUILD_USER and
  KBUILD_BUILD_HOST. Several distributions patch scripts/mkcompile_h to
  achieve this, so let's provide an official way. Also, document the
  KBUILD_BUILD_TIMESTAMP variable while at it.

Michal
