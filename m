Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095Ab2ILTgi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 15:36:38 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49421 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab2ILTgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 15:36:35 -0400
Date: Wed, 12 Sep 2012 12:36:30 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Davidlohr Bueso <dave@gnu.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH v2] lib: gcd: prevent possible div by 0
Message-ID: <20120912193630.GA14933@kroah.com>
References: <1347287719.2561.14.camel@offbook>
 <1347476706.2526.3.camel@offbook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347476706.2526.3.camel@offbook>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 09:05:06PM +0200, Davidlohr Bueso wrote:
> ping? Cc'ing Greg for stable.

Why?  That's not how a patch gets added to the stable tree, right?

greg k-h
