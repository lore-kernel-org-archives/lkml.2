Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504Ab2G0JZA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 05:25:00 -0400
Received: from alice.et.bocholt.fh-gelsenkirchen.de ([193.175.197.63]:41129
	"EHLO alice.et.bocholt.fh-gelsenkirchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751565Ab2G0JY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 05:24:59 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 alice.et.bocholt.fh-gelsenkirchen.de q6R9Otfa001533
From: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] netconsole.txt: "nc" needs "-p" to specify the listening port
In-Reply-To: <CAM_iQpX3EFnoW=Vh2hgJwNPr-whJhcUctCyv_+afFB8DrnHRsQ@mail.gmail.com>
	(Cong Wang's message of "Fri, 27 Jul 2012 17:02:53 +0800")
References: <gir4rxk7c2.fsf@mx10.gouders.net>
	<CAM_iQpX3EFnoW=Vh2hgJwNPr-whJhcUctCyv_+afFB8DrnHRsQ@mail.gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
Date: Fri, 27 Jul 2012 11:24:53 +0200
Message-ID: <gihastk13u.fsf@mx10.gouders.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Greylist: Sender succeeded STARTTLS authentication, not delayed by milter-greylist-4.2.3 (alice.et.bocholt.fh-gelsenkirchen.de [192.168.0.63]); Fri, 27 Jul 2012 11:24:55 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cong Wang <xiyou.wangcong@gmail.com> writes:

> On Fri, Jul 27, 2012 at 2:35 PM, Dirk Gouders
> <gouders@et.bocholt.fh-gelsenkirchen.de> wrote:
>> Hi Jesse,
>>
>> I would like to ask you to check if the documentation of "nc" in
>> netconsole.txt is still correct.  I tried two different netcat packages
>> and both require "-p" to specify the listening port.  I am wondering if
>> that changed after the use of "nc" has been documented.
>
> On Fedora 16, `nc -u -l <port number>` works fine.

Thanks for checking that.

If the information I found is correct, Fedora uses OpenBSD's nc
codebase.  The two netcat packages I tested on a Gentoo system differ in
requiring the -p switch for the port specification.

Dirk
