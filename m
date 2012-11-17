Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494Ab2KQFC6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 00:02:58 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:62520 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728Ab2KQFC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 00:02:56 -0500
Message-ID: <50A71A74.7040706@vlnb.net>
Date: Sat, 17 Nov 2012 00:02:44 -0500
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.28) Gecko/20120313 Mnenhy/0.8.5 Thunderbird/3.1.20
MIME-Version: 1.0
To: =?UTF-8?B?5p2o6IuP56uLIFlhbmcgU3UgTGk=?= <suli@cs.wisc.edu>
CC: General Discussion of SQLite Database <sqlite-users@sqlite.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Richard Hipp <drh@hwaci.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [sqlite] light weight write barriers
References: <CALwJ=MzHjAOs4J4kGH6HLdwP8E88StDWyAPVumNg9zCWpS9Tdg@mail.gmail.com> <m2fw5mtffg.fsf_-_@firstfloor.org> <CABK4GYNKF6LCgsQ5SN+dATtRm-0Qh_QmNdqZqZcj6S98z+ofXg@mail.gmail.com> <5086F5A7.9090406@vlnb.net> <20121025051445.GA9860@thunk.org> <508B3EED.2080003@vlnb.net> <20121027044456.GA2764@thunk.org> <5090532D.4050902@vlnb.net> <20121031095404.0ac18a4b@pyramind.ukuu.org.uk> <5092D90F.7020105@vlnb.net> <20121101212418.140e3a82@pyramind.ukuu.org.uk> <50931601.4060102@symas.com> <20121102123359.2479a7dc@pyramind.ukuu.org.uk> <50A1C15E.2080605@vlnb.net> <20121113174000.6457a68b@pyramind.ukuu.org.uk> <CAK3OfOgK7a9+g-KU8v5-b2d+8-vLb75kuKKQnPK-zeFV1fLmxw@mail.gmail.com> <50A442AF.9020407@vlnb.net> <alpine.DEB.2.02.1211150353080.32408@nftneq.ynat.uz> <CABK4GYNGrbes2Yhig4ioh-37OXg6iy6gqb3u8A2P2_dqNpMqoQ@mail.gmail.com>
In-Reply-To: <CABK4GYNGrbes2Yhig4ioh-37OXg6iy6gqb3u8A2P2_dqNpMqoQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Provags-ID: V02:K0:VjjA/PgoHtzuYldPFVfFuBjAvGEE5HAB03y7kLj557P
 7F0QNEqi8gct93DFADNMWpxbHiT9Npaptc9AB1WemM9eN1RIxM
 ue5tPlcBJIlUD09tG5C6B0P4bP+JokeGW8EeecE7nmfc/crENP
 Xx64lpBMj6ZGi2IpniEUfFSY57JtY5BweHkpTTOz5CQsgP/6sF
 UECfofvRQT5GCUAKLRCyRwDg7tcElcmLUtkuVSIveHe0YTC7O3
 onOr7qScavwSy9RhcVsud/Hh3MKMpyTi5Bicsg4QYsuUO0Hx27
 KiN+2Fg2eWk21L4YjpQtxPk14yzug/VXrlSiTAvFg7V781lFkt
 UP/xDi8iFjKjNSsUEefM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

杨苏立 Yang Su Li, on 11/15/2012 11:14 AM wrote:
> 1. fsync actually does two things at the same time: ordering writes (in a
> barrier-like manner), and forcing cached writes to disk. This makes it very
> difficult to implement fsync efficiently.

Exactly!

> However, logically they are two distinctive functionalities

Exactly!

Those two points are exactly why concept of barriers must be forgotten for sake of 
productivity and be replaced by a finer grained abstractions as well as why they 
where removed from the Linux kernel

Vlad
