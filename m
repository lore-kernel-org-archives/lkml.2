Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861Ab1L1Xsz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 18:48:55 -0500
Received: from beauty.rexursive.com ([150.101.121.179]:37465 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab1L1Xsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 18:48:52 -0500
X-Greylist: delayed 502 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Dec 2011 18:48:52 EST
Message-ID: <1325115628.2029.1.camel@shrek.rexursive.com>
Subject: re: [PATCH] PM / Hibernate: Improve performance of LZO/plain
 hibernation, checksum image
From: Bojan Smojver <bojan@rexursive.com>
To: Barry Song <21cnbao@gmail.com>
Cc: rjw@sisk.pl, linux-pm@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>
Date: Thu, 29 Dec 2011 10:40:28 +1100
In-Reply-To: <CAGsJ_4yXU62GZ38fe7TCH8uKLHJvZ8jtFbJLywqv1kgC7y9V_A@mail.gmail.com>
References: <CAGsJ_4yXU62GZ38fe7TCH8uKLHJvZ8jtFbJLywqv1kgC7y9V_A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-27 at 20:27 +0800, Barry Song wrote:
> this patch is definitely great!

Thanks, I'm glad you liked it.

> any plan to write the same patch for decompress and restore? i think
> that is probably more important than compression and hibernation to
> improve bootup speed.

I'm not sure I understand what you mean here. Can you elaborate?

-- 
Bojan

