Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506Ab0IWHLF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 03:11:05 -0400
Received: from ist.d-labs.de ([213.239.218.44]:41681 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340Ab0IWHLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 03:11:04 -0400
Date: Thu, 23 Sep 2010 09:11:02 +0200
From: Florian Mickler <florian@mickler.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>,
        Stephen Hemminger <shemminger@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] scripts/get_maintainer.pl: add interactive mode
Message-ID: <20100923091102.3699af2d@schatten.dmk.lab>
In-Reply-To: <4012b17a650ddf8f6b882ec9e5e755bd216219a5.1285209493.git.joe@perches.com>
References: <cover.1285209493.git.joe@perches.com>
	<4012b17a650ddf8f6b882ec9e5e755bd216219a5.1285209493.git.joe@perches.com>
X-Mailer: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew!

I don't know if my other mail came through to you, Joe meant his emails
probably got discarded by linux-kernel@vger.kernel.org because of a
missing ">" in your address.

Anyway: 

On Wed, 22 Sep 2010 19:50:09 -0700
Joe Perches <joe@perches.com> wrote:

> From: florian@mickler.org <florian@mickler.org>

From: Florian Mickler <florian@mickler.org> 

My git-send-email somehow dropped the name.


> 
> This is a first version of an interactive mode for
> scripts/get_maintainer.pl .
> 
> It allows the user to interact with the script. Each cc candidate can be
> selected and deselected and a shortlog of authored commits can be
> displayed for each candidate.
> 
> The menu is displayed via STDERR, the end result is outputted to STDOUT.
> This unusual mechanism allows using get_maintainer.pl in interactive mode via
> git send-email --cc-cmd.
> 
> Signed-off-by: Joe Perches <joe@perches.com>


Also, you can add my Signed-Off-By to this, if it is needed.


Thx,
Flo
