Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162Ab1KOS20 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 13:28:26 -0500
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:52593 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757141Ab1KOS2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 13:28:25 -0500
Date: Tue, 15 Nov 2011 13:28:19 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.2-rc2
Message-ID: <20111115182819.GA13495@elliptictech.com>
References: <CA+55aFzWkXNtLe4jxuXfTJzbXgDF+ig2OuGY3ca+nNCJxAtOZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzWkXNtLe4jxuXfTJzbXgDF+ig2OuGY3ca+nNCJxAtOZQ@mail.gmail.com>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-11-15 15:44 -0200, Linus Torvalds wrote:
> Linux 3.2-rc2 is out there now. Well, the git trees are there
> (kernel.org and github), and the tar-file should be all done, but the
> patch is still uploading.

It seems that the tag made it to your repo (on kernel.org), but the
master branch has not been updated?

  % git fetch origin master
  % git rev-parse FETCH_HEAD
  7f80850d3f9fd8fda23a317044aef3a6bafab06b

  % git fetch origin tag v3.2-rc2
  % git rev-parse FETCH_HEAD
  cfcfc9eca2bcbd26a8e206baeb005b055dbf8e37

Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
