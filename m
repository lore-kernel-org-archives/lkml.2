Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499Ab2L2JCc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 04:02:32 -0500
Received: from mail-ia0-f191.google.com ([209.85.210.191]:63246 "EHLO
	mail-ia0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224Ab2L2JC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 04:02:29 -0500
X-Greylist: delayed 2598 seconds by postgrey-1.27 at vger.kernel.org; Sat, 29 Dec 2012 04:02:29 EST
Path: glegroupsg2000goo.googlegroups.com!not-for-mail
Newsgroups: fa.linux.kernel
Date: Sat, 29 Dec 2012 00:19:10 -0800 (PST)
In-Reply-To: <fa.aKiGvXaqF8zkt42DoAyNZWYEe5M@ifi.uio.no>
Complaints-To: groups-abuse@google.com
Injection-Info: glegroupsg2000goo.googlegroups.com; posting-host=137.163.19.9; posting-account=L_Ri8goAAADBuGROTBhW1crNbc8e7dzT
NNTP-Posting-Host: 137.163.19.9
References: <fa.bKjJDjpiXe4ZyttQxy70URjcaYU@ifi.uio.no> <fa.aKiGvXaqF8zkt42DoAyNZWYEe5M@ifi.uio.no>
User-Agent: G2/1.0
X-Google-Web-Client: true
X-Google-IP: 137.163.19.9
MIME-Version: 1.0
Message-ID: <9d57e984-32bd-4d94-8137-6aeec4cf5986@googlegroups.com>
Subject: Re: [PATCH 03/32] gadget: remove only user of aio retry
From: john.wensley@gmail.com
To: fa.linux.kernel@googlegroups.com
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        Zach Brown <zab@redhat.com>, bcrl@kvack.org, jmoyer@redhat.com,
        axboe@kernel.dk, viro@zeniv.linux.org.uk, tytso@mit.edu,
        Kent Overstreet <koverstreet@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 27, 2012 4:08:46 AM UTC+2, Kent Overstreet wrote:
...

Great. Did you measure by how much your changes improve performance?

-- john
