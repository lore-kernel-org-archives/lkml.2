Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790Ab1JJPUy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 11:20:54 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:49550 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751734Ab1JJPUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 11:20:52 -0400
Message-ID: <1318260051.25811.12.camel@Joe-Laptop>
Subject: Re: [PATCH 5/6] udf: Neaten logging output, use vsprintf extension
 %pV
From: Joe Perches <joe@perches.com>
To: Jan Kara <jack@suse.cz>
Cc: NamJae Jeon <linkinjeon@gmail.com>, linux-kernel@vger.kernel.org
Date: Mon, 10 Oct 2011 08:20:51 -0700
In-Reply-To: <20111010150444.GD3944@quack.suse.cz>
References: <CAKYAXd9csZyMXAy_uopb-fHKtY8VBjWD6UVdbQ3QTHYPogLVrw@mail.gmail.com>
	 <cover.1318233879.git.joe@perches.com>
	 <f6af3ca08d9e966de00d77cc9a8251d91666f33f.1318233879.git.joe@perches.com>
	 <20111010150444.GD3944@quack.suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-10 at 17:04 +0200, Jan Kara wrote:
> On Mon 10-10-11 01:08:06, Joe Perches wrote:
> > Remove the warning and error prefixes that duplicate KERN_<level>.
>   Please keep that in the prefix. It's easier to read messages when they
> are that way ...

I think duplicating kernel standard functionality
is not good and this merely increases logging buffer
size.

It's your code, you're the maintainer, fix it up
as you choose.

