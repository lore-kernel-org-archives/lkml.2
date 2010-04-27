Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278Ab0D0V6k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 17:58:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3113 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754390Ab0D0V6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 17:58:38 -0400
Message-ID: <4BD75DDE.7040001@redhat.com>
Date: Tue, 27 Apr 2010 17:57:50 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Valdis.Kletnieks@vt.edu, mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, tzanussi@gmail.com,
       a.p.zijlstra@chello.nl, fweisbec@gmail.com, stefanha@linux.vnet.ibm.com,
       tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf tools: Fix libdw-dev package name in	error
 message
References: <1272292023-9869-1-git-send-email-stefanha@linux.vnet.ibm.com> <tip-f93830fbb06b67848c762f2177c06cc3cbb97deb@git.kernel.org> <5694.1272376100@localhost> <20100427150016.GC8565@ghostprotocols.net>
In-Reply-To: <20100427150016.GC8565@ghostprotocols.net>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo Carvalho de Melo wrote:
> Em Tue, Apr 27, 2010 at 09:48:20AM -0400, Valdis.Kletnieks@vt.edu escreveu:
>> On Tue, 27 Apr 2010 12:59:19 -0000, tip-bot for Stefan Hajnoczi said:
>>> Commit-ID:  f93830fbb06b67848c762f2177c06cc3cbb97deb
>>> Gitweb:     http://git.kernel.org/tip/f93830fbb06b67848c762f2177c06cc3cbb97deb
>>> Author:     Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
>>> AuthorDate: Mon, 26 Apr 2010 15:39:54 -0300
>>> Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
>>> CommitDate: Mon, 26 Apr 2010 15:39:54 -0300
>>>
>>> perf tools: Fix libdw-dev package name in error message
>>>
>>> The headers required for DWARF support are provided by the libdw-dev
>>> package in Debian-based distros.
>>
>> Not all the world is Debian based.  As I mentioned before, the package needed
>> is elfutils-devel on Redhat/Fedora systesm.  For those boxes, you're changing a
>> 'elfutil-dev' that the user can guess is supposed to be -devel, to a package
>> that doesn't exist on Redhat/Fedora.  And to compound it, if the user guesses
>> that you meant libdwarf-devel, that still fails, because that does *not*
>> provide the libdw.h header - that's still in elfutil-devel.
> 
> It works for Red Hat, the message is:
> 
>         msg := $(warning No libdw.h found or old libdw.h found, disables dwarf support. Please install elfutils-devel/libdw-dev);

Right, if someone knows some other package name on other distro,
please tell us.

Thank you,

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
