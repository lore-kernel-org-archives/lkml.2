Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751372Ab0E3Qbs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 12:31:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54692 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750913Ab0E3Qbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 12:31:47 -0400
Date: Sun, 30 May 2010 09:28:09 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Samuel Ortiz <sameo@linux.intel.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT] [2.6.35] MFD pull request
In-Reply-To: <20100528004611.GA24790@sortiz.org>
Message-ID: <alpine.LFD.2.00.1005300925190.4639@i5.linux-foundation.org>
References: <20100528004611.GA24790@sortiz.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 28 May 2010, Samuel Ortiz wrote:
> 
> This is the MFD pull request for the 2.6.35 merge window.

Samuel - this adds the CONFIG_MFD thing, with absolutely _no_ explanation. 
So now people see this totally incomprehensible question:

	Enable Multifunction device drivers? (Y/n)

with no sane way to decide whether they should actually enable it or not.

I'm ok with it being 'y' default, since it's a whole new config option 
that enables pre-existing config options, but _dammit_ people, you need to 
think way more about the Kconfig options you add!

"MFD" isn't even a well-defined term. A lot of people think about printers 
when they hear it. So you really _really_ need to explain what the h*ll 
you are asking people!

		Linus
