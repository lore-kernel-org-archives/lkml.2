Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab1KWQbt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 11:31:49 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:47002 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751434Ab1KWQbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 11:31:48 -0500
Date: Wed, 23 Nov 2011 11:31:47 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: NamJae Jeon <linkinjeon@gmail.com>
cc: Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@samba.org>,
        <linux-cifs@vger.kernel.org>, <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Unix Support <unix-support@ucs.cam.ac.uk>,
        Steve French <smfrench@gmail.com>, <akpm@linux-foundation.org>,
        Anton Altaparmakov <aia21@cam.ac.uk>, <ashishsangwan2@gmail.com>
Subject: Re: CIFS: Rename bug on servers not supporting inode numbers
In-Reply-To: <CAKYAXd965Md2D4mnDbROoNcKZPQs2dERh8y7aDHtoJ+FJcK1QQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1111231131100.2111-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Nov 2011, NamJae Jeon wrote:

> Hi. Alan.
> Would you know why there is no upper/lower case table in nls utf8 ?
> And Currently Surrogate pair is not supported also in nls utf8. Is
> there the reason ?

I don't know.

Alan Stern

