Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833Ab1JKALm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 20:11:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50097 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753745Ab1JKALl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 20:11:41 -0400
Message-ID: <4E9389A5.1080300@zytor.com>
Date: Mon, 10 Oct 2011 17:11:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: "David S. Miller" <davem@davemloft.net>
CC: Greg KH <gregkh@suse.de>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: stable mailing list?
References: <1318290984.7904.127.camel@gandalf.stny.rr.com> <20111011000759.GA28709@suse.de>
In-Reply-To: <20111011000759.GA28709@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2011 05:07 PM, Greg KH wrote:
> On Mon, Oct 10, 2011 at 07:56:23PM -0400, Steven Rostedt wrote:
>> I received a bounce from stable@kernel.org. What should we be Ccing to?
> 
> You should be marking your patch with a:
> 	Cc: stable <stable@kernel.org>
> 
> and when it hits Linus's tree, I properly pick it up.  Right now, the
> mailing list isn't working, and I am considering just having it point to
> a vger list as that makes more sense.  I'll ask Dave to set this up when
> I land as I'm traveling at the moment...
> 

Hi Dave,

Can you set up <stable@vger.kernel.org> and we'll point
<stable@kernel.org> to it?

	-hpa

