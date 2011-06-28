Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665Ab1F1FtX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 01:49:23 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:53856 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755462Ab1F1FsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 01:48:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=C3F2xPQk2KsHfArq1Bw0pj+uZ8lUxm1KGi4HSpmG9oPp+/iCZxOcwsStcSU+AMvO31
         jgnWcFox5fqQTVgJxTJPxbif7HoDTckdGbCVfbibLc0kp/HeMVzdxafX+LV9oEc9iPLe
         UjduHGs46WokzCGYV6PF8Xh1zHIQkbPOlA0qs=
MIME-Version: 1.0
In-Reply-To: <sig.11608c07e8.4E095C34.1020904@containermaster-cmp.de>
References: <BANLkTinC7vfaRWf5TK9gJuQVtVwDkEQFcQ@mail.gmail.com>
	<20110627145442.GA2729@thunk.org>
	<sig.11608c07e8.4E095C34.1020904@containermaster-cmp.de>
Date: Tue, 28 Jun 2011 13:47:58 +0800
Message-ID: <BANLkTi=X0wu8MpRZh21MzMeeDh81CFHH_w@mail.gmail.com>
Subject: Re: random(4) driver questions
From: Sandy Harris <sandyinchina@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johann Meier <recv@containermaster-cmp.de> wrote:

> If you don't have a hardware rnd, you can use an entropy daemon like
> haveged (http://www.issihosts.com/haveged/)

Yes, and there are several other alternatives. Someone suggested a
timer-based daemon earlier in this thread. It looks reasonable at
first glance, but in security matters, I'm reluctant to trust version
0.1 of anything.

Peter Gutmann's cryptlib includes a well-analyzed daemon:
http://www.cs.auckland.ac.nz/~pgut001/cryptlib/

John Denker's turbid, using a sound card without microphone,
looks very good:
http://www.av8n.com/turbid/paper/turbid.htm
