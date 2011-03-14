Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997Ab1CNKCQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 06:02:16 -0400
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:43539 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab1CNKCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 06:02:14 -0400
Date: Mon, 14 Mar 2011 11:02:05 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: chenliu@asset.uwaterloo.ca
Cc: schwidefsky@de.ibm.com, linux390@de.ibm.com, cotte@de.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]early: Fix possible overlapping data buffer
Message-ID: <20110314100205.GA2520@osiris.boeblingen.de.ibm.com>
References: <20110311160442.GA13495@asset.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110311160442.GA13495@asset.uwaterloo.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 11:04:42AM -0500, chenliu@asset.uwaterloo.ca wrote:
> Thanks Heiko. I've followed your advice to give a new patch here.
> ---------------------------------
> 
> This patch fixed bugzilla #12965:
> https://bugzilla.kernel.org/show_bug.cgi?id=12965
> 
> The original code contains some inproper use of sprintf
> function where a buffer is used both as input string
> as well as output string. It should remember the written
> bytes in the previous and use that as the offset for
> later writing. Also replace sprintf with snprintf.
> 
> Signed-off-by: Chen Liu <chenliunju@gmail.com>

Hi Chen,

I still want a patch where the From: and Signed-off-by: lines
are identical. Otherwise I won't take the patch.

Also you didn't answer my other question: did you actually
test that after your change the code still works?
If not, then I would have to do that.

The patch looks ok so far (besides two lines that could
be removed).

Thanks,
Heiko
