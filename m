Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab0IMK0g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 06:26:36 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34123 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab0IMK0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 06:26:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=i/U00jpYzPw3FOZnfcrmcHcsubYklIy7B7bTUSlgcHVUe5G/cavrNEvteHQAYYr1WE
         PXd9pJ+akS/ZpgEoo72UZtlN5q6Xown86khCYmv9CM/UIR5NncAmqBBN8HaJsldZ9olH
         /xxZqW6XGaFlpqNeBa7k2bz/GWDZZ+d3EhYiA=
Message-ID: <4C8DFC56.8020006@gmail.com>
Date: Mon, 13 Sep 2010 12:26:30 +0200
From: Maurus Cuelenaere <mcuelenaere@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; nl; rv:1.9.2.9) Gecko/20100825 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
        Peter Korsgaard <peter.korsgaard@barco.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Michal Nazarewicz <m.nazarewicz@samsung.com>,
        linux-usb <linux-usb@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Fabien Chouteau <fabien.chouteau@barco.com>,
        david Brownell <dbrownell@users.sourceforge.net>,
        Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>,
        LKML <linux-kernel@vger.kernel.org>, MeeGo <meego-dev@meego.com>,
        "Wang, Qi" <qi.wang@intel.com>, "Wang, Yong Y" <yong.y.wang@intel.com>,
        Andrew <andrew.chih.howe.khor@intel.com>,
        Intel OTC <joel.clark@intel.com>,
        "Foster, Margie" <margie.foster@intel.com>,
        Arjan <arjan@linux.intel.com>,
        Toshiharu Okada <okada533@dsn.okisemi.com>,
        Takahiro Shimizu <shimizu394@dsn.okisemi.com>,
        Tomoya Morinaga <morinaga526@dsn.okisemi.com>
Subject: Re: [PATCH] USB device driver of Topcliff PCH
References: <4C85EE6F.6000706@dsn.okisemi.com> <AANLkTikSb-16eACaR16Uh2c7K=2yT3e+Vna=Z2Tt-x=6@mail.gmail.com> <000a01cb52fb$78fc2310$66f8800a@maildom.okisemi.com>
In-Reply-To: <000a01cb52fb$78fc2310$66f8800a@maildom.okisemi.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Op 13-09-10 06:23, Masayuki Ohtake schreef:
> Hi Maurus

Hi Ohtake,

>
> My reply comments are included in the following.
> I will resubmit after modified
>
> Thanks Ohtake
>
> From: Maurus Cuelenaere <mcuelenaere@gmail.com>
> Date: Tue, 7 Sep 2010 14:53:05 +0200
>> 2010/9/7 Masayuki Ohtake <masa-korg@dsn.okisemi.com>
>>> This patch adds the USB device driver of Topcliff PCH.
>>> Topcliff PCH is the platform controller hub that is going to be used in
>>> Intel's upcoming general embedded platform. All IO peripherals in
>>> Topcliff PCH are actually devices sitting on AMBA bus.
>>> Topcliff PCH has USB device I/F. Using this I/F, it is able to access system
>>> devices connected to USB device.
>>>
>>> Signed-off-by: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
>> No need to mail all these people, just the maintainers and appropriate mailing
>> lists will do.
> [masa]
> I have question. Please tell me.
> Whom should I submit patch to?
>  TO: LKML and maintainers
> Is it correct?
>
> The maintainer was got the following scripts.
> "./scripts/get_maintainer.pl"

If you do scripts/get_maintainer.pl --rolestats <patch>, you'll see why
get_maintainer.pl picked these persons. I generally CC anyone that's "above"
commit_signer or that I know has an important relation to the patch (e.g. the
author of a driver you're editing).

If there are any mailing lists listed (linux-usb in this case), be sure to CC
them too (except LKML, I wouldn't CC them unless it's a special case like the
changes are kernel-wide or need to reviewed by a wide variation of audience or
...)

IIRC, these rules are also explained at Documentation/Submit*.

--
Maurus Cuelenaere
