Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab0INMu5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 08:50:57 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41818 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250Ab0INMuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 08:50:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=s9/HrqaJztOkMGwBOlSp+WAM427ffBZf5WZ3AI3rKpGMNBkdIeAyGdlJw3g2Rr9aSk
         rQPC4WEN3XUYoQCagRiOHi6EWfZDEhg7SgI/qx89ux97BZJS1KgAPx1u99H638vH6DJd
         h4S0VwyCrjDZmdn5qqvQiRohg1/vqx1KeewbU=
Message-ID: <4C8F6FA5.7020201@gmail.com>
Date: Tue, 14 Sep 2010 14:50:45 +0200
From: Maurus Cuelenaere <mcuelenaere@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; nl; rv:1.9.2.9) Gecko/20100825 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: =?UTF-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
CC: Masayuki Ohtake <masa-korg@dsn.okisemi.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Peter Korsgaard <peter.korsgaard@barco.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
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
References: <4C85EE6F.6000706@dsn.okisemi.com> <AANLkTikSb-16eACaR16Uh2c7K=2yT3e+Vna=Z2Tt-x=6@mail.gmail.com> <000a01cb52fb$78fc2310$66f8800a@maildom.okisemi.com> <4C8DFC56.8020006@gmail.com> <op.viyyabj27p4s8u@pikus>
In-Reply-To: <op.viyyabj27p4s8u@pikus>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Op 13-09-10 13:31, Michał Nazarewicz schreef:
> On Mon, 13 Sep 2010 12:26:30 +0200, Maurus Cuelenaere <mcuelenaere@gmail.com> wrote:
>> If there are any mailing lists listed (linux-usb in this case), be sure to CC
>> them too (except LKML, I wouldn't CC them unless it's a special case like the
>> changes are kernel-wide or need to reviewed by a wide variation of audience or
>> ...)
>
> Actually, Documentation/SubmittingPatches says:
>
>     Unless you have a reason NOT to do so, CC
>     linux-kernel@vger.kernel.org.
>

Ah, well IMHO it's better not to spam LKML with subsystem-related stuff..

--
Maurus Cuelenaere
