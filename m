Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab1HQXUq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 19:20:46 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:49090 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab1HQXUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 19:20:44 -0400
Message-ID: <4E4C4CC2.2070702@lwfinger.net>
Date: Wed, 17 Aug 2011 18:20:34 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110616 SUSE/3.1.11 Thunderbird/3.1.11
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
        Pavel Ivanov <paivanof@gmail.com>,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        Jouni Malinen <jmalinen@atheros.com>,
        Vasanthakumar Thiagarajan <vasanth@atheros.com>,
        Senthil Balasubramanian <senthilkumar@atheros.com>,
        linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath9k: make driver usable standalone
References: <CAG1a4rt_NML2Q_Mkd+RuvLvft4D6inG7c9=s6kpAXqtAvatOBg@mail.gmail.com> <CA+XFjipM1Qup3bcJos_ikwzoaWoa3GdYqK0WBUqEHBNR6V6LfQ@mail.gmail.com> <CAG1a4rsyfPrrrf-mzt3HAM6YHHjaHTcd2rbtYiwqLkUCP=j8pQ@mail.gmail.com>            <CA+XFjipsVukKYchfmDv48PAKsD2PUxT+7E8epRuKFynGwk=Bag@mail.gmail.com> <24649.1313621503@turing-police.cc.vt.edu>
In-Reply-To: <24649.1313621503@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2011 05:51 PM, Valdis.Kletnieks@vt.edu wrote:
> On Wed, 17 Aug 2011 18:25:49 +0200, Gábor Stefanik said:
>
>> Iwconfig and iwlist are themselves deprecated. Iw is the new wireless
>> configuration tool.
>
> Somebody better tell Fedora Rawhide - as of the version released on July 27,
> their 'initscripts' RPM was still using iwconfig in /etc/sysconfig/network-scripts/ifup-wireless
>
> So don't be quite so fast to be declaring WIRELESS_EXT dead just yet.

Well, any distro is free to include any package they want. They can even devote 
resources to maintaining it after it is abandoned. Given the feelings among 
developers about the WEXT methods, I doubt that will happen.

The distro is also including one of the drivers that need WEXT, which is what 
the OP refused to do. If and when all such drivers are converted or removed, the 
distro is still free to patch in the WEXT code, but again I doubt that will happen.

Anyone using deprecated methods has been warned.

Larry
