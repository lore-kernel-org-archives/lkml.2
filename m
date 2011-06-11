Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab1FKS26 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 14:28:58 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:45330 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751318Ab1FKS24 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 14:28:56 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=azhEO7Xd3Lffz9MMEBpjggAoMcjsqzNAgHlUOBjQJ8s/OFc7IBjwVNOjAJerbFeAMPb8Jmj2X1s35KRWmGKG/iJO0Zf73lrooDPCHFG7FzLXuMaNuXkzSjsJKWGAbtlj;
Date: Sat, 11 Jun 2011 11:28:53 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Stratos Psomadakis <psomas@ece.ntua.gr>, Matt Mackall <mpm@selenic.com>,
        david@lang.hm, linux-kernel@vger.kernel.org,
        Frank Kingswood <frank@kingswood-consulting.co.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: ketchup script and 3.0
Message-Id: <20110611112853.6eb09925.rdunlap@xenotime.net>
In-Reply-To: <20110611060211.GB6522@cr0>
References: <4DEDD5F4.1070602@kingswood-consulting.co.uk>
	<1307451186.4204.953.camel@calx>
	<4DEE808D.6020405@ece.ntua.gr>
	<1307477435.4204.968.camel@calx>
	<4DEE8AD9.3050508@ece.ntua.gr>
	<1307479572.4204.977.camel@calx>
	<alpine.DEB.2.02.1106071349000.28905@asgard.lang.hm>
	<1307480372.4204.987.camel@calx>
	<4DEE9695.7060805@ece.ntua.gr>
	<05cba294449b86a9aa22cec4abc7e98f.squirrel@xenotime.net>
	<20110611060211.GB6522@cr0>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Jun 2011 14:02:11 +0800 Américo Wang wrote:

> On Tue, Jun 07, 2011 at 02:33:53PM -0700, Randy Dunlap wrote:
> >
> >It's also an issue for scripts/patch-kernel, unless I decide
> >to just kill (drop) it.
> >
> 
> I think we should merge ketchup and then drop scripts/patch-kernel.

Sounds good to me.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
