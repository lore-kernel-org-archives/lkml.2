Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809Ab1C1RC7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 13:02:59 -0400
Received: from smtp-out.google.com ([216.239.44.51]:20678 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750Ab1C1RC5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 13:02:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rno+L2HFvCNwP2Su63m5r4dBOV5FMyHa5lOFZ2cgQCxV7Es1MUEOwJsifXT52yFuyT
         4MuEq9+LwmrXu5yEe33g==
MIME-Version: 1.0
In-Reply-To: <20110328131705.GB7226@redhat.com>
References: <1300756245-12380-1-git-send-email-ctalbott@google.com>
	<20110322150905.GD3757@redhat.com>
	<AANLkTinTiEAFG1F1df380BiDtVFVr=nCsSqhM9__XdQ4@mail.gmail.com>
	<20110322181231.GJ3757@redhat.com>
	<AANLkTi=uB_Wv08xu4SzpjCJ_9isvDPsN=ojTH=wAaDoS@mail.gmail.com>
	<20110323204146.GK13315@redhat.com>
	<AANLkTi=-7gZhEU6qRAt+uGBkb2s2=bkXC81WNScDM6jA@mail.gmail.com>
	<20110325213202.GB21593@redhat.com>
	<AANLkTikTLCdHceaD98zxw90Qb=PuTvfALWELa=Yp6UAC@mail.gmail.com>
	<20110328131705.GB7226@redhat.com>
Date: Mon, 28 Mar 2011 10:02:53 -0700
Message-ID: <AANLkTikptjDTP0Xd5B8tBy5UwqNYttJXCa36QpJUj1bt@mail.gmail.com>
Subject: Re: [PATCH 0/3] cfq-iosched: Fair cross-group preemption
From: Chad Talbott <ctalbott@google.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Gui Jianfeng <guijianfeng@cn.fujitsu.com>, jaxboe@fusionio.com,
        linux-kernel@vger.kernel.org, mrubin@google.com, teravest@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 6:17 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Fri, Mar 25, 2011 at 04:53:13PM -0700, Chad Talbott wrote:
>> I prefer option a) - so much so that even with the older CFQ group
>> implementation we did work to merge the RT and BE service trees to
>> achieve that behavior.  But I see that using blkio.class is a poor
>> choice of interface name.  I will rename the interface and resubmit
>> the patch series (also with Gui's suggestion to keep the "_device"
>> suffix for consistency).
>
> Do you need this feature to be global or per device or both?

Per-device.

Chad
