Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668Ab1GZVa1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 17:30:27 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:39843 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753307Ab1GZVaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 17:30:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=GsEvqT4PxD91S6aOVH5Kt1eLSm8jHFLVmkGxBJT3jgA08QSL27HcY/K29BNQ+i4SMC3NGDT3zXkd/EY6CwnkKLM/mnBvxdNCe7K/Vs9ZHJQQI7n7TxFHyKhW5eeVTTjL;
Date: Tue, 26 Jul 2011 14:30:23 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        alan@linux.intel.com
Subject: Re: linux-next: Tree for July 26 (gpu vs. staging/gma500)
Message-Id: <20110726143023.cc2d7f81.rdunlap@xenotime.net>
In-Reply-To: <20110726155744.5c1bee67177bd94211ed8c2b@canb.auug.org.au>
References: <20110726155744.5c1bee67177bd94211ed8c2b@canb.auug.org.au>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jul 2011 15:57:44 +1000 Stephen Rothwell wrote:

> Hi all,

drivers/staging/built-in.o: In function `drm_gem_private_object_init':
(.text+0x8e170): multiple definition of `drm_gem_private_object_init'
drivers/gpu/built-in.o:(.text+0x9a20): first defined here


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
