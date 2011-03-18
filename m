Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab1CRAHr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 20:07:47 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55121 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754677Ab1CRAHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 20:07:44 -0400
Date: Fri, 18 Mar 2011 00:07:41 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Tony Luck <tony.luck@gmail.com>
Cc: Xiaotian Feng <xtfeng@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Some fixes for pstore (Was Re: [git pull] mnt_devname queue)
Message-ID: <20110318000741.GE22723@ZenIV.linux.org.uk>
References: <20110316235608.GY22723@ZenIV.linux.org.uk>
 <AANLkTimF9ExskxBmebk7X2=g5S6OK5vAa05G1cgeVVCP@mail.gmail.com>
 <20110317072344.GZ22723@ZenIV.linux.org.uk>
 <AANLkTin=5jSzZKXLL=A+dbRn1jB+tPg56LmjthzC02ui@mail.gmail.com>
 <20110317104434.GB22723@ZenIV.linux.org.uk>
 <4d827eae305473e2bf@agluck-desktop.sc.intel.com>
 <20110317224252.GC22723@ZenIV.linux.org.uk>
 <AANLkTim5pj0J4VaYRzK8_8fpb0=hO5yxhAL48egiTE2e@mail.gmail.com>
 <4d82994b3095310bde@agluck-desktop.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d82994b3095310bde@agluck-desktop.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 04:29:15PM -0700, Tony Luck wrote:
> > Send the updated patch my way, please.
> 
> Here it is.

Applied.  I'll add simple_pin_fs()/mntput() to deal with the races as a
separate commit and put that into tonight's pull request.
