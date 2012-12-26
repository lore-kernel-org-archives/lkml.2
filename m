Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052Ab2LZCOx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 21:14:53 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:47572 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751641Ab2LZCOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 21:14:51 -0500
Message-ID: <1356488089.28255.1.camel@joe-AO722>
Subject: Re: [PATCH 1/5] f2fs: Introduce some information prints in the
 mount path
From: Joe Perches <joe@perches.com>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: jaegeuk.kim@samsung.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Date: Tue, 25 Dec 2012 18:14:49 -0800
In-Reply-To: <CAKYAXd_-c4Mh0hQHBiNDVOrWmq=TVXEuoaWd1hzrA70t9p6=ag@mail.gmail.com>
References: <1356145725-19940-1-git-send-email-linkinjeon@gmail.com>
	 <1356486933.16178.144.camel@kjgkr>
	 <CAKYAXd_-c4Mh0hQHBiNDVOrWmq=TVXEuoaWd1hzrA70t9p6=ag@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-12-26 at 11:10 +0900, Namjae Jeon wrote:
> 2012/12/26, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> > Hi,
> Hi Jaegeuk.
> >
> > Could you make them follow the file system convention?
> > Something like "F2FS: blah blah~".
> Yes,  I agree.
> 
> >
> > Otherwise, how about adding a debugging function to express the prefix?
> Okay, I will send you the patches included your suggestion.

Add

#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

before any #include

