Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab0EIJf3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 05:35:29 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:57621 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661Ab0EIJf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 05:35:28 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4BE681D4.3070000@s5r6.in-berlin.de>
Date: Sun, 09 May 2010 11:35:16 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100415 SeaMonkey/1.1.18
MIME-Version: 1.0
To: florian@mickler.org
CC: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>,
       Stephen Hemminger <shemminger@vyatta.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] get_maintainer.pl: optionally ignore non-maintainer
 tags
References: <1273356373.704.56.camel@Joe-Laptop.home> <1273396544-4189-1-git-send-email-florian@mickler.org>
In-Reply-To: <1273396544-4189-1-git-send-email-florian@mickler.org>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

florian@mickler.org wrote:
> Using --git to determine who to send a patch to, it is not
> reasonable to include people that only reported an issue or tested a
> patch. Thus we restrict the candidates to be the one's listed with
> Reviewed-By, Signed-Off-By and Acked-By tags.
> 
> Signed-Off-By:'s because that are people who are responsible for the code
> in question.
> 
> Reviewed-By:'s because people responsible for the code in question
> obviously thought that the review-feedback for this changeset by that
> person was valuable.
> 
> The Acked-By: is questionable, but as people listed with this tag
> tend to be active linux gatekeepers, false positives are tolerable.

This and "get_maintainer.pl: only list maintainers by default" in
conjunction:  Reviewed-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
But *don't* record this in the git history because then somebody might
think I want to be Cc'd on get_maintainer.pl patches.
-- 
Stefan Richter
-=====-==-=- -=-= -=--=
http://arcgraph.de/sr/
