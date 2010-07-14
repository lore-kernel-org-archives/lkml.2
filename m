Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932462Ab0GOFer (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 01:34:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50576 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932440Ab0GOFeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 01:34:46 -0400
Message-ID: <4C3E1F0B.7080407@zytor.com>
Date: Wed, 14 Jul 2010 22:33:15 +0200
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "H.J. Lu" <hjl.tools@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Palfrader <peter@palfrader.org>, Avi Kivity <avi@redhat.com>,
        Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        stable@kernel.org, stable-review@kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Glauber Costa <glommer@redhat.com>,
        Zachary Amsden <zamsden@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [patch 134/149] x86, paravirt: Add a global synchronization point
 	for pvclock
References: <20100707124731.GJ15122@anguilla.noreply.org>	<4C3C8CE5.1080705@redhat.com>	<20100713162207.GC15122@anguilla.noreply.org>	<4C3C9589.4090602@redhat.com>	<4C3C96EC.8060901@redhat.com>	<4C3C9839.4090404@redhat.com>	<20100713172526.GE15122@anguilla.noreply.org>	<AANLkTini61PZO1_icO2jRcBmMvWm24splgjZA1lUgab2@mail.gmail.com>	<AANLkTikDo0UsJxGekCdFgDMEHOONLiRe7ZOSf_j0ZKjf@mail.gmail.com>	<4C3CAE8F.10900@goop.org>	<4C3CE560.5050701@zytor.com>	<4C3CFB8B.1090804@goop.org>	<AANLkTilmqWhHFO5zpfe5g53adUd18nIDli2tJt54k3rg@mail.gmail.com>	<4C3DF1BE.2070404@goop.org>	<4C3DF447.1000801@zytor.com>	<4C3DF519.6030406@goop.org>	<4C3DF7AF.7010402@zytor.com>	<4C3DFA88.5020007@goop.org>	<4C3DFD12.3050700@zytor.com>	<AANLkTikA8SO42kOgHZb-6YuhM7GPnmg81IAX5vEk_Cqk@mail.gmail.com>	<4C3E096B.8050505@zytor.com>	<AANLkTil5uvr9sWc_o3HmOsJ0iaJJjaMkkrMwF0BsEdHg@mail.gmail.com>	<4C3E11BD.2090503@zytor.com> <AANLkTilKr6wr_wAE0nzXDsffWYWNdGf2_EqMXzRSKJMu@mail.gmail.com> <4C3E27E7.3010706@goop.org>
In-Reply-To: <4C3E27E7.3010706@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For those that are interested:

http://gcc.gnu.org/bugzilla/show_bug.cgi?id=44943

	-hpa
