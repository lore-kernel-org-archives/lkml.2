Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757056Ab1KKLob (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 06:44:31 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:49752 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752620Ab1KKLoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 06:44:30 -0500
Message-ID: <1321011869.6676.3.camel@Joe-Laptop>
Subject: Re: [PATCH] get_maintainers.pl: Follow renames when looking up
 commit signers
From: Joe Perches <joe@perches.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Date: Fri, 11 Nov 2011 03:44:29 -0800
In-Reply-To: <1320998367.16747.127.camel@dagon.hellion.org.uk>
References: <1320998367.16747.127.camel@dagon.hellion.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-11 at 07:59 +0000, Ian Campbell wrote:
[]
> diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
[]
> @@ -95,7 +95,7 @@ my %VCS_cmds_git = (
> -	"git log --no-color --since=\$email_git_since " .
> +	"git log --no-color --follow --since=\$email_git_since " .

Signed-off-by: Joe Perches <joe@perches.com>


