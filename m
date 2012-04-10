Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758846Ab2DJOTD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 10:19:03 -0400
Received: from fieldses.org ([174.143.236.118]:39655 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754213Ab2DJOTB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 10:19:01 -0400
Date: Tue, 10 Apr 2012 10:18:58 -0400
From: "bfields@fieldses.org" <bfields@fieldses.org>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: "Trond.Myklebust@netapp.com" <Trond.Myklebust@netapp.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Grace period
Message-ID: <20120410141858.GG18465@fieldses.org>
References: <4F7F230A.6080506@parallels.com>
 <20120406234039.GA20940@fieldses.org>
 <4F82C6E3.3030009@parallels.com>
 <20120409232618.GI10508@fieldses.org>
 <4F841987.6090909@parallels.com>
 <20120410133735.GE18465@fieldses.org>
 <4F843F53.9050301@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F843F53.9050301@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 06:10:27PM +0400, Stanislav Kinsbursky wrote:
> Well, I can do this to restart grace only for "init_net" and a
> printk with your message and information, that it affect only
> init_net.
> Looks good to you?

Yep, thanks!

--b.
