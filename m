Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145Ab0HTNZw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 09:25:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:47589 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033Ab0HTNZu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 09:25:50 -0400
Subject: Re: [PATCH -V18 04/13] vfs: Allow handle based open on symlinks
From: Peter Zijlstra <peterz@infradead.org>
To: Neil Brown <neilb@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        viro@zeniv.linux.org.uk, adilger@sun.com, corbet@lwn.net,
        npiggin@suse.de, hooanon05@yahoo.co.jp, bfields@fieldses.org,
        miklos@szeredi.hu, linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com,
        philippe.deniel@CEA.FR, linux-kernel@vger.kernel.org
In-Reply-To: <20100820195303.20b17210@notabene>
References: <1282269097-26166-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1282269097-26166-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <20100820083057.GA10039@infradead.org>  <20100820195303.20b17210@notabene>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 20 Aug 2010 15:25:29 +0200
Message-ID: <1282310729.2605.989.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-20 at 19:53 +1000, Neil Brown wrote:
> With futexes we suddenly get a file descriptor for something we could never
> get a file descriptor on before and that doesn't seem to be a problem. 

FWIW

commit 82af7aca56c67061420d618cc5a30f0fd4106b80
Author: Eric Sesterhenn <snakebyte@gmx.de>
Date:   Fri Jan 25 10:40:46 2008 +0100

    Removal of FUTEX_FD

