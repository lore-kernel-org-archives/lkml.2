Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751146Ab1CTNjU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 09:39:20 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:49665 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889Ab1CTNjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 09:39:18 -0400
X-RZG-AUTH: :IGUXYVOIf/Z0yAghYbpIhzghmj8icP68r1arC3zTx2B9G7/X5zri/u5Y1+fsZ6BmRA==
X-RZG-CLASS-ID: mo00
Message-ID: <4D860381.30706@die-jansens.de>
Date: Sun, 20 Mar 2011 14:39:13 +0100
From: Arne Jansen <lists@die-jansens.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Jeffrin Jose <ahiliation@yahoo.co.in>
CC: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: aligning with spaces [was: Re: format fixes]
References: <20110320104527.GA3120@debian.Jeff>
In-Reply-To: <20110320104527.GA3120@debian.Jeff>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.03.2011 11:45, Jeffrin Jose wrote:
> I have created a patch with fixes and format
> error by replacing spaces with tabs.

The CodingStyle guide seems to me a big vague on this topic, but
checkpatch.pl has a clear idea of what is right and wrong. But
the formerly present indentation seems to me totally valid.
Use tab to indent to the current indentation level, then continue
with spaces for the alignment of broken-up lines. This has a
few advantages. One of them is that the code still looks neat with
a different tab size (of course, no one ever does that). Another is,
that editing is easier if you change the name of the function and
with it the needed alignment for the following lines.
If we really require using tabs as much as possible for aligning, we
should also _only_ use tabs for it and require e.g. 2 tabs for
broken-up lines.
In fact, the example in CodingStyle uses only tabs and does not try
to align the double quotes of the broken-up string with each other.

--Arne

