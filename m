Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab1GXXkf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 19:40:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18422 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596Ab1GXXkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 19:40:32 -0400
Date: Sun, 24 Jul 2011 19:40:29 -0400
From: Dave Jones <davej@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: kdevtmpfs oops since yesterdays vfs merge
Message-ID: <20110724234029.GA4881@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20110724231701.GA1707@redhat.com>
 <20110724232812.GN24703@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110724232812.GN24703@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 12:28:12AM +0100, Al Viro wrote:
 > On Sun, Jul 24, 2011 at 07:17:01PM -0400, Dave Jones wrote:
 > > I see an oops in handle_create when I try to boot current tree..
 > > 
 > > full trace:
 > > https://s3.amazonaws.com/twitpic/photos/large/355006460.jpg?AWSAccessKeyId=AKIAJF3XCCKACR3QDMOA&Expires=1311550232&Signature=IIO%2Bya1uEDJzSXTD0DXh2%2BdZpoU%3D
 > 
 > Where in handle_create() is that?  At least dump objdump -d of your
 > devtmpfs.o someplace readable...

http://codemonkey.org.uk/devtmpfs.s

	Dave
