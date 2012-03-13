Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965216Ab2CMAbx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:31:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33123 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964867Ab2CMAbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:31:51 -0400
Message-ID: <4F5E956F.3070108@zytor.com>
Date: Mon, 12 Mar 2012 17:31:43 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Jan Kratochvil <jan.kratochvil@redhat.com>
CC: Denys Vlasenko <dvlasenk@redhat.com>,
        Roland McGrath <roland@hack.frob.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Kushal Das <kdas@redhat.com>
Subject: Re: Extending coredump note section to contain filenames
References: <4F5A3A4D.1020008@redhat.com> <20120309172934.GA18173@host2.jankratochvil.net> <4F5DE6A4.2030303@redhat.com> <20120312165359.GA32400@host2.jankratochvil.net> <4F5E76CE.4030601@zytor.com> <20120312223144.GA9636@host2.jankratochvil.net> <4F5E91DE.80609@zytor.com> <20120313002725.GA17828@host2.jankratochvil.net>
In-Reply-To: <20120313002725.GA17828@host2.jankratochvil.net>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2012 05:27 PM, Jan Kratochvil wrote:
> On Tue, 13 Mar 2012 01:16:30 +0100, H. Peter Anvin wrote:
>> That's quite absurd if you think about it... we're talking about each
>> individual library, not necessarily the root binary.
> 
> Denys is also working on ABRT which already dumps a lot of useful info
> associated with a core file:
> 	abrt_version analyzer architecture cmdline component coredump count
> 	dso_list environ executable hostname kernel maps os_release package
> 	pid pwd reason time uid username uuid var_log_messages
> 
> I find the local copy instances of the files of specific build the same or
> even less less useful info than those files above.
> 
> One should start implementing dumping all the info above info Linux kernel
> before the filenames are worth it.
> 

This is basically providing the dso_list and executable information.
Several of the other things you list above (cmdline, environ, pid,
reason, maps) are already part of a core file.  The rest sounds like an
RFE to me.

	-hpa
