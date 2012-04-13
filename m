Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350Ab2DMXSg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 19:18:36 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36722 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757131Ab2DMXSe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 19:18:34 -0400
MIME-Version: 1.0
In-Reply-To: <20120413230525.GA13995@burratino>
References: <20120412011313.GA23764@kroah.com>
	<CAMP44s2q+bQE3-zsX4bs=sQDt4jf8eE5bwZ8V88UjodjRyAjog@mail.gmail.com>
	<20120412144626.GA14868@kroah.com>
	<CAMP44s1T4EVwpzDuV_vV0Zh-5WcPCwdw9eeOfL17Geqp_UFN-Q@mail.gmail.com>
	<CAJ-VmonhwvnXPKa=LNOR4W0ZTXZqWmzw4UrsKLoE0YN_Bu0FzQ@mail.gmail.com>
	<CAMP44s2JPvhEB6Eb049Z_bToAFncHKMEheuyaxyhC=bnh2GJVg@mail.gmail.com>
	<20120413105746.10ffb120@stein>
	<CAMP44s0RohH9tPiM5qCDT57XBV=iO66PZkSjYVxA6Usg1qJPtw@mail.gmail.com>
	<20120413154216.476a02ac@stein>
	<CAMP44s10KVwL5pY=Q5hWfyUtU6CvvZZ4Bcg-fEY9dAhSL306aQ@mail.gmail.com>
	<20120413230525.GA13995@burratino>
Date: Sat, 14 Apr 2012 02:18:33 +0300
Message-ID: <CAMP44s0OdVBTwVtCoru-xvB=LVtO56jgku7X-0a7mUz1=iVCzw@mail.gmail.com>
Subject: Re: [ 00/78] 3.3.2-stable review
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Adrian Chadd <adrian@freebsd.org>,
        Greg KH <gregkh@linuxfoundation.org>, Sergio Correia <lists@uece.net>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 14, 2012 at 2:05 AM, Jonathan Nieder <jrnieder@gmail.com> wrote:
> Felipe Contreras wrote:
>> On Fri, Apr 13, 2012 at 4:42 PM, Stefan Richter wrote:
>
>>> If you do not like to wait for Linus and Greg, you simply have to derive
>>> an own kernel which additionally contains your preferred fixes.
>>
>> Yes, because clearly everybody thinks the process is perfect, and
>> criticizing it is heresy.
>
> Close.  Not everyone.  For example, you do not think the process is
> perfect.

So you think the process is *perfect*? I would have expected
reasonable people to know that nothing is perfect, realize the
sarcasm, and meditate for a second. But it seems expecting somebody to
agree the process is not perfect is too much to ask.

> I don't think Stefan meant the above as tongue-in-cheek, for what it's
> worth.  Another stable kernel with different rules really would be an
> interesting exercise, and would probably fulfill a need for a certain
> audience.
>
> It's not like nobody does that already, anyway.  For example, I hear
> Fedora has a kernel that they maintain well for a different audience,
> using different rules.

Of course, although the difference with the stable kernel would be
very small if the only thing added is an extra rule for acceptance:
"It reverts an earlier
patch to 'stable'."

But "we do this, and if you don't like it you can do whatever you
want" is not a valid argument in favor of the status quo, even though
it's used a lot in open source, and it's true, and there's nothing
wrong with that... I yet have to see an answer to my arguments, and
not a regurgitated answer for something nobody is proposing.

Cheers.

-- 
Felipe Contreras
