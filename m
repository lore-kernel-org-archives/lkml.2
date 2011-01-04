Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516Ab1ADJCh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 04:02:37 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:38434 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab1ADJCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 04:02:34 -0500
X-Auth-Info: fuKJPdOKIbfKrEhPRmNuCS97EgaVt15+EXSSnUY+lvk=
From: Andreas Schwab <schwab@linux-m68k.org>
To: yangsheng <sickamd@gmail.com>
Cc: linux-kernel@vger.kernel.org, adilger@dilger.ca,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        swhiteho@redhat.com, sickadm@gmail.com
Subject: Re: [PATCH resend] Update atime from future.
References: <1294131418-3835-1-git-send-email-sickamd@gmail.com>
X-Yow: Well, I'm INVISIBLE AGAIN..  I might as well pay a visit to the
 LADIES ROOM...
Date: Tue, 04 Jan 2011 10:02:29 +0100
In-Reply-To: <1294131418-3835-1-git-send-email-sickamd@gmail.com> (yangsheng's
	message of "Tue, 4 Jan 2011 16:56:58 +0800")
Message-ID: <m2d3od11p6.fsf@whitebox.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

yangsheng <sickamd@gmail.com> writes:

> -	 * Is the previous atime value older than a day? If yes,
> +	 * Is the previous atime value old than a day? If yes,

Why did you change that comment?

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
