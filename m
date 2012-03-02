Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317Ab2CBOQQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 09:16:16 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55771 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab2CBOQO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 09:16:14 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of difrost.kernel@gmail.com designates 10.14.120.210 as permitted sender) smtp.mail=difrost.kernel@gmail.com; dkim=pass header.i=difrost.kernel@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120302140038.GD5054@shiny>
References: <CADDYkjS5VJeYyHzqumazQ0qKg+HwA6GO+zYSJj7rkHNZFwjcoQ@mail.gmail.com>
	<E15A491F-62E2-4518-939F-07B3AB4C3E65@mit.edu>
	<20120301143859.GX5054@shiny>
	<CADDYkjQ8jgWUo7=eAeMjve0iRmVZMcrjjbqnvPq0SchE5W9Fqg@mail.gmail.com>
	<20120302140038.GD5054@shiny>
Date: Fri, 2 Mar 2012 15:16:12 +0100
Message-ID: <CADDYkjT8apYQpdZqr1gZKiHbm9xfTaLr=8GEJF0VKF9neHwgOg@mail.gmail.com>
Subject: Re: getdents - ext4 vs btrfs performance
From: Jacek Luczak <difrost.kernel@gmail.com>
To: Chris Mason <chris.mason@oracle.com>,
        Jacek Luczak <difrost.kernel@gmail.com>, Theodore Tso <tytso@mit.edu>,
        linux-ext4@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/3/2 Chris Mason <chris.mason@oracle.com>:
> On Fri, Mar 02, 2012 at 11:05:56AM +0100, Jacek Luczak wrote:
>>
>> I've took both on tests. The subject is acp and spd_readdir used with
>> tar, all on ext4:
>> 1) acp: http://91.234.146.107/~difrost/seekwatcher/acp_ext4.png
>> 2) spd_readdir: http://91.234.146.107/~difrost/seekwatcher/tar_ext4_readir.png
>> 3) both: http://91.234.146.107/~difrost/seekwatcher/acp_vs_spd_ext4.png
>>
>> The acp looks much better than spd_readdir but directory copy with
>> spd_readdir decreased to 52m 39sec (30 min less).
>
> Do you have stats on how big these files are, and how fragmented they
> are?  For acp and spd to give us this, I think something has gone wrong
> at writeback time (creating individual fragmented files).

How big? Which files?

-Jacek
