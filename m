Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256Ab2ICHCU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 03:02:20 -0400
Received: from canardo.mork.no ([148.122.252.1]:45537 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923Ab2ICHCS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 03:02:18 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>, linux-input@vger.kernel.org,
        chunkeey@googlemail.com, linville@tuxdriver.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: input0: bad kobj_uevent_env content in show_uevent()
Organization: m
References: <20120902075946.GA21198@localhost> <87harg35kh.fsf@nemi.mork.no>
	<20120902163831.GA26191@localhost> <20120903002241.GA20054@kroah.com>
Date: Mon, 03 Sep 2012 09:01:48 +0200
In-Reply-To: <20120903002241.GA20054@kroah.com> (Greg Kroah-Hartman's message
	of "Sun, 2 Sep 2012 17:22:41 -0700")
Message-ID: <87oblnegir.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> On Mon, Sep 03, 2012 at 12:38:31AM +0800, Fengguang Wu wrote:
> 
>> It also works reliably for me: 300 boots without a single failure.
>> 
>> Tested-by: Fengguang Wu <fengguang.wu@intel.com> 
>
> Thanks for figuring this out.  I'll apply it for 3.6, but work to get
> rid of CONFIG_HOTPLUG completly for 3.7 as it just causes problems.

OK, do you want me to propose some commit message, or do you prefer to
write something coherent yourself instead?  In any case, if you need it
for the oneline hack:

Signed-off-by: Bjørn Mork <bjorn@mork.no>



Bjørn
