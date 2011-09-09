Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933699Ab1IILNI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 07:13:08 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:36204 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933516Ab1IILNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 07:13:06 -0400
From: Pedro Alves <pedro@codesourcery.com>
Organization: CodeSourcery
To: Denys Vlasenko <dvlasenk@redhat.com>
Subject: Re: [PATCH v3] Make PTRACE_SEIZE set ptrace options specified in 'data'
Date: Fri, 9 Sep 2011 12:12:59 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38-11-generic; KDE/4.7.0; x86_64; ; )
Cc: Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org,
        Denys Vlasenko <vda.linux@googlemail.com>
References: <1315506333.18043.49.camel@dhcp-25-63.brq.redhat.com>
In-Reply-To: <1315506333.18043.49.camel@dhcp-25-63.brq.redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201109091212.59889.pedro@codesourcery.com>
X-OriginalArrivalTime: 09 Sep 2011 11:13:02.0528 (UTC) FILETIME=[70C0C400:01CC6EE1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 September 2011 19:22:04, Denys Vlasenko wrote:
> Make PTRACE_SEIZE set ptrace options specified in 'data' parameter
>     
> This can be used to close a few corner cases in strace where we get
> unwanted racy behavior after attach, but before we have a chance
> to set options (the notorious post-execve SIGTRAP comes to mind),

I'm still confused on why you're raising the SIGTRAP argument.  Did you see

 https://lkml.org/lkml/2011/9/8/7

?

-- 
Pedro Alves
