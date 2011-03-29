Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab1C2LeJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 07:34:09 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:23547 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782Ab1C2LeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 07:34:07 -0400
Content-Type: text/plain; charset=UTF-8
From: Chris Mason <chris.mason@oracle.com>
To: David Sterba <dave@jikos.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Btrfs updates for 2.6.39
In-reply-to: <20110328132527.GM17108@twin.jikos.cz>
References: <1301312919-sup-1222@think> <20110328132527.GM17108@twin.jikos.cz>
Date: Tue, 29 Mar 2011 07:32:48 -0400
Message-Id: <1301398227-sup-108@think>
User-Agent: Sup/git
Content-Transfer-Encoding: 8bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4D91C39E.00A2,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from David Sterba's message of 2011-03-28 09:25:28 -0400:
> Hi,
> 
> Chris, you did not add my sign-of on the unaligned fix I've posted, nor
> the tested-by or reported-by. Looking again into the mail, it seems like
> some automated-misprocessing picked the first part of the mail altough
> there was properly formated patch after '--' marker (and I've verified
> this is correct before sending the mail).
> 
> Can you please fix that?
> Patch reference: https://patchwork.kernel.org/patch/645671/

Sorry, looks like I messed that one up.  patchwork did bring in the
comments in a funny way and I didn't notice before the pull request went
out.

-chris
