Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540Ab2DSDXl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 23:23:41 -0400
Received: from gate.crashing.org ([63.228.1.57]:54353 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180Ab2DSDXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 23:23:40 -0400
Message-ID: <1334805798.3143.25.camel@pasglop>
Subject: Re: [git pull] vfs and fs fixes
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Anton Blanchard <anton@au1.ibm.com>
Date: Thu, 19 Apr 2012 13:23:18 +1000
In-Reply-To: <20120417052511.GU6589@ZenIV.linux.org.uk>
References: <20120417052511.GU6589@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>       ext4: fix endianness breakage in ext4_split_extent_at()

That smells like something we'd want in -stable no ?

Cheers,
Ben.


