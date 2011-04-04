Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672Ab1DDVGq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 17:06:46 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:52679 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755428Ab1DDVGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 17:06:42 -0400
Date: Mon, 4 Apr 2011 22:06:39 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [REGRESSION] 2.6.39-rc1: f23eb2b breaks console output
Message-ID: <20110404210639.GA6133@sucs.org>
References: <BANLkTinVd8-VNM+uJ0HReA3cd6DaF-wA=A@mail.gmail.com> <20110404194230.GA8785@sucs.org> <BANLkTik_MNB+4vWXw2k0-B-2B1_4MO3HMg@mail.gmail.com> <BANLkTi=oZ8a8EwbraRm4n-wjmyrLe+MySg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=oZ8a8EwbraRm4n-wjmyrLe+MySg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 05, 2011 at 12:42:54AM +0400, Alexander Beregalov wrote:
> On 4 April 2011 23:59, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> >
> > Does this patch make a difference?
> Yes, it works on top of 2.6.39-rc1-00184-g78fca1b9

This fixes the problem for me too (on top of
148086bb64694cc91624bab2a550d50f800eb4b7 ).

Tested-by: Sitsofe Wheeler <sitsofe@yahoo.com>

-- 
Sitsofe | http://sucs.org/~sits/
