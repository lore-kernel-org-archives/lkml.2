Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751105Ab2HGQIO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 12:08:14 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:54044 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab2HGQIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 12:08:12 -0400
Message-ID: <50213D69.3060904@gmail.com>
Date: Tue, 07 Aug 2012 12:08:09 -0400
From: Salar Ali Mumtaz <salaarali@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xconfig: Display dependency values in debug_info
References: <1343256982-11421-1-git-send-email-salaarali@gmail.com> <50107EB7.8000009@xenotime.net> <CA+jpPM=nrbpDJpaka6xAp4dbEOQjJrtwQWtUXwi_gGS9b4yK-A@mail.gmail.com> <50117812.5080302@xenotime.net>
In-Reply-To: <50117812.5080302@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-07-26 01:02 PM, Randy Dunlap wrote:

> The added y/n/m are clear, but the "!FRV FRV" is confusing,
> isn't it?
> 
> 

Is this notation clear ?

Kernel support for ELF binaries (BINFMT_ELF)

type: boolean
unknown property: symbol
    dep: ( MMU [=y] && (BROKEN [n] || !FRV [= ""]) ) [=y]
prompt: Kernel support for ELF binaries
    dep: ( MMU [=y] && (BROKEN [n] || !FRV [= ""]) ) [=y]
default: y
    dep: ( MMU [=y] && (BROKEN [n] || !FRV [= ""]) ) [=y]


If not, could you suggest a better way to represent this information?

Thanks.
