Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894Ab2LCSrE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 13:47:04 -0500
Received: from [206.117.179.246] ([206.117.179.246]:59392 "EHLO labridge.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750874Ab2LCSrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 13:47:01 -0500
Message-ID: <1354560401.3524.3.camel@joe-AO722>
Subject: Re: [PATCH 1/3] cifs: Remove unused cEVENT macro
From: Joe Perches <joe@perches.com>
To: Steve French <smfrench@gmail.com>, Theodore Tso <tytso@mit.edu>
Cc: Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@samba.org>,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org
Date: Mon, 03 Dec 2012 10:46:41 -0800
In-Reply-To: <CAH2r5mtbhZWJu1eoahDSo84Wr=6jrSDVdwEVnQWYxztU72T2nQ@mail.gmail.com>
References: <cover.1354217746.git.joe@perches.com>
	 <7176cb20d420849d72aa004e40a404049362da7f.1354217746.git.joe@perches.com>
	 <20121130064710.1bcd227b@tlielax.poochiereds.net>
	 <CAH2r5mtbhZWJu1eoahDSo84Wr=6jrSDVdwEVnQWYxztU72T2nQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-30 at 09:39 -0600, Steve French wrote:
> But ... the need still remains for more tracing for cifs (I run into
> this a few times a month at least when debugging) - does anyone have
> any ideas for how to add dynamic trace points to cifs (has anyone even
> done it for the vfs?) - is there any file system that does a good job
> defining dynamic trace points?

I believe ext4 is the only filesystem with significant use of
tracepoints.

Ted? Any tips you care to give as to best implementation methods?


