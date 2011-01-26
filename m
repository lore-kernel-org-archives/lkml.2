Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027Ab1AZQcH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 11:32:07 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:59346 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615Ab1AZQcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 11:32:05 -0500
Date: Wed, 26 Jan 2011 16:32:04 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Dr. Bernd Feige" <bernd.feige@uniklinik-freiburg.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.37 x86 ncpfs regression: kernel BUG at
 include/linux/dcache.h:340 with >1366 files in directory
Message-ID: <20110126163203.GP22723@ZenIV.linux.org.uk>
References: <1296053700.2684.19.camel@pst15.ukl.uni-freiburg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296053700.2684.19.camel@pst15.ukl.uni-freiburg.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 03:55:00PM +0100, Dr. Bernd Feige wrote:
> Hi,
> 
> On 2.6.37 I get the following when listing one of our Novell directories
> containing 9499 files (no subdirs; note that this works fine on
> 2.6.36.x):

Plain .37?  Not .38-rc1?

> I assumed that the changes to ncpfs in 2.6.37 caused this, but reverting
> them did not solve the problem. Turning off preemption and group
> scheduling did not help either. So I'm lost and my spare time is running
> out, thought I'd report it nonetheless.

3825bdb7ed920845961f32f364454bee5f469abb may be a suspect...
