Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613Ab0H1Px7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 11:53:59 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:50453 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234Ab0H1Px6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 11:53:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=hbnefEU1T6V3r4bQxLWk63GWyBO8C06a9L0aBjU7gnqVQzuISu3excyOap/mcRJLsR
         +ZdKZgW4PNn/TRJ08cgVklgr9GQ91nROszQ1r9ZRWP2z7bYcbxMb4RtnCD5owDvr6Hoj
         DXzqlXFBdpL3pxlU1pUy350/7h6rv6sE4aoH4=
Date: Sat, 28 Aug 2010 12:52:51 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH] perf: Remove newline character from perror() argument
Message-ID: <20100828155251.GP2973@ghostprotocols.net>
References: <89e77b54659bc3798b23a5596c2debb7f6f4cf27.1283010281.git.matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89e77b54659bc3798b23a5596c2debb7f6f4cf27.1283010281.git.matt@console-pimps.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Aug 28, 2010 at 04:46:19PM +0100, Matt Fleming escreveu:
> If we include a newline character in the string argument to perror()
> then the output will be split across two lines like so,
> 
>     Unable to read perf file descriptor
>     : No space left on device
> 
> Deleting the newline character prints a much more readable error,
> 
>     Unable to read perf file descriptor: No space left on device

Thanks, applying.

- Arnaldo
