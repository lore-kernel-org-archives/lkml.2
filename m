Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760054Ab2FAPS1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 11:18:27 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40752 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446Ab2FAPSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 11:18:25 -0400
Subject: Re: seq_file: Use larger buffer to reduce time traversing lists
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
        Al Viro <viro@zeniv.linux.org.uk>, nstraz@redhat.com
In-Reply-To: <1338562897.2760.1528.camel@edumazet-glaptop>
References: <1338547193.2708.16.camel@menhir>
	 <1338552626.2760.1510.camel@edumazet-glaptop>
	 <1338553486.2708.25.camel@menhir>
	 <1338554890.2760.1517.camel@edumazet-glaptop>
	 <1338556468.2708.41.camel@menhir>
	 <1338557229.2760.1520.camel@edumazet-glaptop>
	 <1338560283.2708.59.camel@menhir>
	 <1338562627.2760.1526.camel@edumazet-glaptop>
	 <1338562897.2760.1528.camel@edumazet-glaptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Jun 2012 17:18:20 +0200
Message-ID: <1338563900.2760.1529.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-01 at 17:01 +0200, Eric Dumazet wrote:

> All unix sockets are linked into a single list, no hash table, so its
> not very easy right now.
> 

Oops, there is a hash table, so patch is coming ;)


