Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071Ab1JNSzU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 14:55:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47170 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753135Ab1JNSzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 14:55:19 -0400
Message-ID: <4E988564.40905@zytor.com>
Date: Fri, 14 Oct 2011 11:54:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Procedural requirements for restoring kernel.org accounts
References: <20111014152100.GA11717@kroah.com>
In-Reply-To: <20111014152100.GA11717@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

In addition to Greg's points, we have had some problems with the way
some people submitting keys.

1. Please send your key fingerprints to <keys@kernel.org> (the former
   temporary address <keys@zytor.com> now forwards to this address.)

   In particular, keys sent to any other address including privately to
   me or John will not be processed.  Keys are being processed by John
   in batches to manage the workload.

2. Make sure your keys are uploaded to pgp.mit.edu (directly or
   indirectly) before you send them.

3. Make sure there is an encryption subkey associated with your key!
   If your key is a sign-only key you need an encryption key signed
   with your signing key; please give both fingerprints in the request.

4. If there is no signing path back to the kernel.org team people then
   please work with your fellow developers, co-workers etc. to obtain
   such a link.  If nothing possible sooner, there will be key signings
   at KS and LCE which are less than two weeks away.

	-hpa
