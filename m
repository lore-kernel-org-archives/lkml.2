Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391Ab1F2QjM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 12:39:12 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:46202 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757351Ab1F2QjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 12:39:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=AiKEBSZ2liSvAkbBtAGvL9Sce/EqeghnVlOBiTDYjcfOnPL6bB870LlY7rdErsW3PokmYaPKztANrFHDh6jOAWoimU12k1p/DHFnjY6w6hYH7TkKoKcgeC/z7+EwSQKc;
Date: Wed, 29 Jun 2011 09:38:59 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: [PATCH 06/29] gma500: revamp frame buffer creation and handling
Message-ID: <20110629093859.64f145ab@jbarnes-desktop>
In-Reply-To: <20110628220429.898.69509.stgit@bob.linux.org.uk>
References: <20110628220151.898.15775.stgit@bob.linux.org.uk>
	<20110628220429.898.69509.stgit@bob.linux.org.uk>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jun 2011 23:04:30 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> From: Alan Cox <alan@linux.intel.com>
> 
> Restructure this to work the same way as the i915 frame buffer does. That
> cleans up various chunks of code.
> 
> We can now set a mode in modetest but mode restore is a bit iffy

Note that modetest doesn't do the VT dance, so if you don't clean
things up in your ->lastclose the right mode probably won't come back.

-- 
Jesse Barnes, Intel Open Source Technology Center
