Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab0DXQuj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 12:50:39 -0400
Received: from DMZ-MAILSEC-SCANNER-7.MIT.EDU ([18.7.68.36]:61944 "EHLO
	dmz-mailsec-scanner-7.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752357Ab0DXQui convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 12:50:38 -0400
X-AuditID: 12074424-b7b9dae000002832-d8-4bd3215c5941
Subject: Re: [PATCH 1/3] Documentation: -stable rules: upstream commit ID requirement reworded
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <20100424150231.GA9572@suse.de>
Date: Sat, 24 Apr 2010 12:50:28 -0400
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <D9326E3C-6428-4DB4-B9C8-5A4EA7B61729@MIT.EDU>
References: <20100422222928.GA3268@kroah.com> <1271976016-3584-1-git-send-email-gregkh@suse.de> <20100424020253.GP14986@thunk.org> <4BD2B5EC.4020808@s5r6.in-berlin.de> <4BD2BA28.3000109@s5r6.in-berlin.de> <20100424150231.GA9572@suse.de>
To: Greg KH <gregkh@suse.de>
X-Mailer: Apple Mail (2.1078)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 24, 2010, at 11:02 AM, Greg KH wrote:
>> 
>>> Apparently Greg's scripts modify the
>>> changelogs respectively when he cherry-picks from linux-2.6.git, so the
>>> requirement is also always fulfilled with this alternative submission path.
> 
> No, it's not a real submission patch, and yes, I always require a git
> commit id in the patch.  If I don't have it, it is explained in the
> patch why it is not in Linus's tree.
> 
> Don't worry, I think the current wording is fine.

Thanks for clarifying, I didn't realize the wording was referring to the cc: stable@ path, where the stable team adds the commit id reference themselves once it's available.   

-- Ted


