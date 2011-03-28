Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751587Ab1C1JOa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 05:14:30 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60466 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab1C1JO3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 05:14:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KTZRxN4ODybuVawaqI2Z3b0/80Md+wwa2O99KhBCqgs7aNiG21duDTRYRqGgHh9M7X
         Ym5NM+57qV1V2hZHp53ib7vd1BtMLaJj6PbuWj6js2AWGz0BJxJcmDUVF19v/wIAF8ge
         id5im7txmjzZc02OhjnKmgmaColrj92TRP4tM=
MIME-Version: 1.0
In-Reply-To: <AANLkTinp4=c9qmVyfocUk_ydJ3PV50b9UckNhJJNFsFm@mail.gmail.com>
References: <201011181650.00152.roucaries.bastien@gmail.com>
	<AANLkTik=+smaiGNwVw0pDBXexVd=trsz9aSawuqLZP6k@mail.gmail.com>
	<20101223034229.GF1739@nowhere>
	<201101300108.32383.roucaries.bastien@gmail.com>
	<20110308141847.GB1837@nowhere>
	<AANLkTinp4=c9qmVyfocUk_ydJ3PV50b9UckNhJJNFsFm@mail.gmail.com>
Date: Mon, 28 Mar 2011 11:14:28 +0200
Message-ID: <AANLkTimYiRYZVXtxLBNeGcG=KVJTTiaGn+XGYP2Y=XMo@mail.gmail.com>
Subject: Re: Reiserfs deadlock in 2.6.36
From: Bastien ROUCARIES <roucaries.bastien@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 8, 2011 at 4:22 PM, Bastien ROUCARIES
<roucaries.bastien@gmail.com> wrote:
> On Tue, Mar 8, 2011 at 3:18 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>> On Sun, Jan 30, 2011 at 01:08:29AM +0100, Bastien ROUCARIES wrote:
>>> Le jeudi 23 décembre 2010 04:42:33, Frederic Weisbecker a écrit :
>>> Hi,
>>>
>>> I take me more than two days of testing to reporduce this bugs with trace enabled. My filesystem was quite slow and this bugs seems
>>> to be timing related.
>>>

Any news of this bug? Could I do something to help ?

bastien
>
> Ok bastien
>
