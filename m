Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038Ab0J1KGg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 06:06:36 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:50174 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755005Ab0J1KGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 06:06:33 -0400
Date: Thu, 28 Oct 2010 12:04:59 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: fix unbalanced mutex unlock
Message-ID: <20101028120459.2f255b8c@absol.kitzblitz>
In-Reply-To: <20101027205043.GG3194@thunk.org>
References: <20101026011534.0bb7cb64@absol.kitzblitz>
	<20101027205043.GG3194@thunk.org>
Organization: -
X-Face: "fF&[w2"Nws:JNH4'g|:gVhgGKLhj|X}}&w&V?]0=,7n`jy8D6e[Jh=7+ca|4~t5e[ItpL5
 N'y~Mvi-vJm`"1T5fi1^b!&EG]6nW~C!FN},=$G?^U2t~n[3;u\"5-|~H{-5]IQ2
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* "Ted Ts'o" <tytso@mit.edu>:
> On Tue, Oct 26, 2010 at 01:15:34AM +0200, Nicolas Kaiser wrote:
> > Although the mutex isn't locked yet, if ext4_li_request_new
> > fails, the mutex would get unlocked on the error path.

> Nice catch, thanks!!  I've applied a fix to the ext4 patch queue.

Thanks for augmenting the patch - looks good to me :)

Best regards,
Nicolas Kaiser
