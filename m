Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613Ab1LVTZr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 14:25:47 -0500
Received: from tn-76-7-162-101.sta.embarqhsd.net ([76.7.162.101]:45531 "EHLO
	animx.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752448Ab1LVTZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 14:25:43 -0500
X-Greylist: delayed 1302 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Dec 2011 14:25:43 EST
Date: Thu, 22 Dec 2011 14:03:59 -0500
From: Wakko Warner <wakko@animx.eu.org>
To: Gaurav Saxena <grvsaxena419@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Intercepting system calls
Message-ID: <20111222190359.GF604@animx.eu.org>
Mail-Followup-To: Gaurav Saxena <grvsaxena419@gmail.com>,
	linux-kernel@vger.kernel.org
References: <CAOh0hwO03GJ2ApNW6GV5fJKJ4S+hTv3An7vLTO4qaL4U9grdJg@mail.gmail.com>
 <CAFLxGvyWWCAfk-fCCc3NhCE=KbE-Y7ivO5gynSbCubxPC8d-uw@mail.gmail.com>
 <CAOh0hwOpzXRp9k70qK6rWURE5414c0=A2ALEBtL=77xxDW9hiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOh0hwOpzXRp9k70qK6rWURE5414c0=A2ALEBtL=77xxDW9hiw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gaurav Saxena wrote:
> Oh. I will not do it then, could you suggest me something so that I
> could prevent unlink on some file say using kernel support. I want to
> save file on unlink how could I do that without kernel support, or how
> could I do that using a kernel module.

I wrote a library that can be loaded in userspace that does this.  It's not
very polished, but it works for me.  I use it for rsync when I want files
"deleted" but not from the filesystem.  It creates a .deleted directory in
the $PWD.

If you're interested, I can send it to you.  I have it working on i386 and
amd64.

-- 
 Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
 million bugs.
