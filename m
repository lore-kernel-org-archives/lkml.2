Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573Ab1E0Qyp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 12:54:45 -0400
Received: from fn.samba.org ([216.83.154.106]:56759 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754725Ab1E0Qyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 12:54:44 -0400
X-Greylist: delayed 459 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 May 2011 12:54:44 EDT
Date: Fri, 27 May 2011 09:47:02 -0700
From: Jeremy Allison <jra@samba.org>
To: Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Big performance improvements seen with cifs async write
 patches even over localhost
Message-ID: <20110527164702.GB28520@samba2>
Reply-To: Jeremy Allison <jra@samba.org>
References: <BANLkTinVOaFwkCf33iKNk8GjqiiBEF5N3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinVOaFwkCf33iKNk8GjqiiBEF5N3w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 12:14:19AM -0500, Steve French wrote:
> Did some informal testing of Jeff Layton's cifs async_write patch set
> tonight (recent kernel). Copying 700MB sequentially was 20% faster
> from cifs kernel client to Samba 3.6 with his patches - even mounted
> over localhost (where network latency is a much smaller issue) and
> with a slow laptop drive!
> 
> I was simply doing
> 
> time dd if=/dev/zero of=/mnt/null bs=1M count=700
> 
> repeated 4 times each way (with old module, and with same code with
> Jeff's cifs async write code builtin), deleting the target file in
> between each run.
> 
> I am looking forward to trying this over GigE tomorrow to servers with
> faster disks.

Very nice ! Now where's my encrypted transport Steve ? :-) :-)

Jeremy.
