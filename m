Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508Ab1JOGmw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 02:42:52 -0400
Received: from 1wt.eu ([62.212.114.60]:34325 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096Ab1JOGmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 02:42:52 -0400
Date: Sat, 15 Oct 2011 08:42:42 +0200
From: Willy Tarreau <w@1wt.eu>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Answers to some common kernel.org account questions
Message-ID: <20111015064242.GA23349@1wt.eu>
References: <20111014152100.GA11717@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111014152100.GA11717@kroah.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Fri, Oct 14, 2011 at 09:21:00AM -0600, Greg KH wrote:
> WHAT ABOUT FILE UPLOADS?
> 
> The "robot signing" of uploaded files that was used in the past is no
> longer considered to be sufficiently secure, so a new policy has been
> instituted.  A new tool ("kup") has been developed to help with the
> implementation of that policy; it works in a manner similar to the
> upload system used by the Debian project.
> 
> The kup tool will require developers to sign files with their PGP key
> prior to uploading to kernel.org.  This mechanism will keep the private
> signing keys from ever being stored on kernel.org (or any other server).
> More information will be made available once the file upload capability
> is restored.

Please reassure me, we will only have to upload the sig, not the whole
file ? I'm assuming that it will still be possible to generate the files
from the git tree (which should produce the exact same file, hence the
same sig). I'm asking because uploading 2*75 MB kernels will take slightly
more than two hours at full load assuming the link does not break at all
during this time, while a git push of one hundred patches only takes a
few seconds. This is a huge difference in efficiency and reliability !

Regards,
Willy

