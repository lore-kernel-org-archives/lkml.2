Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635Ab1CRSdv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 14:33:51 -0400
Received: from sous-sol.org ([216.99.217.87]:56825 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753937Ab1CRSdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 14:33:44 -0400
Date: Fri, 18 Mar 2011 11:33:39 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Sid Boyce <sboyce@blueyonder.co.uk>
Cc: LKML Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: pstore build error
Message-ID: <20110318183339.GV23536@sequoia.sous-sol.org>
References: <4D832BD0.4030809@blueyonder.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4D832BD0.4030809@blueyonder.co.uk>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sid Boyce (sboyce@blueyonder.co.uk) wrote:
>   CC      fs/pstore/inode.o
> fs/pstore/inode.c:253:2: error: unknown field ‘get_sb’ specified in
> initializer

https://lkml.org/lkml/2011/3/17/447
