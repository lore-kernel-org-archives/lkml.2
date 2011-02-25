Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127Ab1BYM17 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 07:27:59 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55867 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932079Ab1BYM16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 07:27:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=mnl0LJUn1oByKgTEESn624U5CWAHEXwd08QM13HXzA4W4P3xdfhxrvQSchJdnyP7yc
         9AwvfZsa+shX6hKVmmRZj4xQAtrySiMRFePZZbSKMxqhT0PsDgLEBef5h4u+xmAPROMV
         g0zirtHGmeDmGTln3wLpxem478ySrwouJbDpI=
From: Peter Korsgaard <jacmet@sunsite.dk>
To: grant.likely@secretlab.ca
Cc: dbrownell@users.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] mcp23s08: support mcp23s17 variant
References: <1297773895-12640-1-git-send-email-jacmet@sunsite.dk>
Date: Fri, 25 Feb 2011 13:27:47 +0100
In-Reply-To: <1297773895-12640-1-git-send-email-jacmet@sunsite.dk> (Peter
	Korsgaard's message of "Tue, 15 Feb 2011 13:44:55 +0100")
Message-ID: <87bp20qoxo.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Peter" == Peter Korsgaard <jacmet@sunsite.dk> writes:

 Peter> mpc23s17 is very similar to the mcp23s08, except that registers
 Peter> are 16bit wide, so extend the interface to work with both
 Peter> variants.

 Peter> The s17 variant also has an additional address pin, so adjust
 Peter> platform data structure to support up to 8 devices per SPI
 Peter> chipselect.

 Peter> Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
 Peter> ---
 Peter> Changes since v1:
 Peter> - Add mcp23s08_ops callbacks for 8 and 16 bit instead of handling both
 Peter>   in the same accessor function as requested by Grant.
 Peter> - Don't use a temporary buffer for 8bit version of read_regs -
 Peter>   Stack addresses are not DMA safe.

Ping? Any comments?

-- 
Bye, Peter Korsgaard
