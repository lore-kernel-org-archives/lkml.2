Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab2FZV6a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 17:58:30 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:37665 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab2FZV62 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 17:58:28 -0400
Date: Tue, 26 Jun 2012 16:58:20 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Anders Kaseorg <andersk@MIT.EDU>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, dash@vger.kernel.org
Subject: Re: [PATCH v2] fifo: Do not restart open() if it already found a
 partner
Message-ID: <20120626215820.GA18624@burratino>
References: <1340712298-4583-1-git-send-email-andersk@mit.edu>
 <20120626202009.GA382@burratino>
 <alpine.DEB.2.00.1206261656000.3236@dr-wily.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <alpine.DEB.2.00.1206261656000.3236@dr-wily.mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anders Kaseorg wrote:

> Signed-off-by: Anders Kaseorg <andersk@mit.edu>
> ---
> Changes from v1:
> • Change wait_for_partner return from true/false to 0/-ERESTARTSYS.
> • Mention that the demo program doesn’t always work for some.
> • Remove some unneeded braces from the demo program’s CHECK() macro.

Yep, I don't have anything left to complain about.  Looks obviously
correct to my inexpert eyes.

Reviewed-by: Jonathan Nieder <jrnieder@gmail.com>
