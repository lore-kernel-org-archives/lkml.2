Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636Ab1GXX2P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 19:28:15 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47947 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596Ab1GXX2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 19:28:13 -0400
Date: Mon, 25 Jul 2011 00:28:12 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: kdevtmpfs oops since yesterdays vfs merge
Message-ID: <20110724232812.GN24703@ZenIV.linux.org.uk>
References: <20110724231701.GA1707@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110724231701.GA1707@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 24, 2011 at 07:17:01PM -0400, Dave Jones wrote:
> I see an oops in handle_create when I try to boot current tree..
> 
> full trace:
> https://s3.amazonaws.com/twitpic/photos/large/355006460.jpg?AWSAccessKeyId=AKIAJF3XCCKACR3QDMOA&Expires=1311550232&Signature=IIO%2Bya1uEDJzSXTD0DXh2%2BdZpoU%3D

Where in handle_create() is that?  At least dump objdump -d of your
devtmpfs.o someplace readable...
