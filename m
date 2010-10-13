Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776Ab0JMLXx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 07:23:53 -0400
Received: from canuck.infradead.org ([134.117.69.58]:37167 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609Ab0JMLXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 07:23:52 -0400
Date: Wed, 13 Oct 2010 07:23:51 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Kieran Bingham <kieranbingham@gmail.com>
Cc: Marco Stornelli <marco.stornelli@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>
Subject: Re: [PATCH 15/16] pramfs: test module
Message-ID: <20101013112351.GA16422@infradead.org>
References: <4CB1EBDD.8050509@gmail.com>
 <4CB301E4.40405@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CB301E4.40405@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 11, 2010 at 01:24:04PM +0100, Kieran Bingham wrote:
> >@@ -0,0 +1,49 @@
> >+/*
> >+ * FILE NAME fs/pramfs/namei.c
> FILE NAME != namei.c

Yes, that's why you should never do such filename comments which are not
only utterly prone to be out of data, but also 100% useless.

