Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab0KZLtS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 06:49:18 -0500
Received: from mail1.slb.deg.dub.stisp.net ([84.203.253.98]:1228 "HELO
	mail1.slb.deg.dub.stisp.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750880Ab0KZLtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 06:49:17 -0500
Message-ID: <4CEF9E68.9080200@draigBrady.com>
Date: Fri, 26 Nov 2010 11:47:52 +0000
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: "Frank A. Kingswood" <frank@kingswood-consulting.co.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: atomically swap two files
References: <icmfu2$nga$1@dough.gmane.org>
In-Reply-To: <icmfu2$nga$1@dough.gmane.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/11/10 20:11, Frank A. Kingswood wrote:
> Hi!
> 
> Is it possible to swap two files in an atomic way, so that after the
> syscall either the two files have exchanged names or neither has been
> modified?
> 
> I suspect that btrfs could do it, but I'm wondering about ext3/4.

I don't think there is anything equivalent to exchangedata() on Linux
http://developer.apple.com/library/mac/#DOCUMENTATION/Darwin/Reference/ManPages/man2/exchangedata.2.html

I've written some notes on atomically replacing
file contents with standard tools here:
http://www.pixelbeat.org/docs/unix_file_replacement.html

cheers,
Pádraig.
