Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932734Ab2EVVTs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 17:19:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15671 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932477Ab2EVVTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 17:19:44 -0400
X-Authority-Analysis: v=2.0 cv=cssZYiEi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=wom5GMh1gUkA:10 a=iZIf2Kua5wEA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=ANUXcTrbAAAA:8 a=Z_TYFZcxmql5NrnISFkA:9 a=CjuIK1q_8ugA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Date: Tue, 22 May 2012 17:19:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: kconfig-frontends-3.4.0-0 released
Message-ID: <20120522211941.GA30024@home.goodmis.org>
References: <201205222221.05548.yann.morin.1998@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201205222221.05548.yann.morin.1998@free.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 10:21:05PM +0200, Yann E. MORIN wrote:
> Hello All!
> 
> I'm pleased to announce the release of kconfig-frontends 3.4.0-0!
> Go download it there:
>     http://ymorin.is-a-geek.org/download/kconfig-frontends/kconfig-frontends-3.4.0-0.tar.xz
>     http://ymorin.is-a-geek.org/download/kconfig-frontends/kconfig-frontends-3.4.0-0.tar.bz2
> 
> The kconfig-frontends package provides the kconfig parser, as well as all the
> kconfig frontends and utilities, packaged using the traditional autotools, so
> the kconfig infrastructure is easy to deploy, either locally or system-wide.
> 
> What's new since 3.3.0-0:
>   - all programs are intalled with the 'kconfig-' prefix by default
>   - the kconfig documentation has been added
>   - the parser's headers are isntalled into their own sub-dir
>   - some side utilities have been added from the Linux kernel tree:
>     - kconfig-diff      show differences between two .config files

I'm curious, how is this different than scripts/diffconfig ?

-- Steve

>     - kconfig-gettext   prepare catalog of options strings for L10n
>     - kconfig-merge     merge .config fragments
>     - kconfig-tweak     get and set .config optiond from the command line
> 
